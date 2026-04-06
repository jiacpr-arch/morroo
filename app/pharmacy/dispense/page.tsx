'use client'

import { useEffect, useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import {
  type PharmacyDrug, type DrugStock,
  formatDate, getDaysToExpiry, isExpired,
} from '@/lib/pharmacy-types'

interface DispenseForm {
  drug_id: string
  quantity: string
  reference: string
  notes: string
  performed_by: string
}

const emptyForm: DispenseForm = {
  drug_id: '',
  quantity: '',
  reference: '',
  notes: '',
  performed_by: 'staff',
}

export default function DispensePage() {
  const [drugs, setDrugs] = useState<PharmacyDrug[]>([])
  const [form, setForm] = useState<DispenseForm>(emptyForm)
  const [search, setSearch] = useState('')
  const [showDropdown, setShowDropdown] = useState(false)
  const [selectedDrug, setSelectedDrug] = useState<PharmacyDrug | null>(null)
  const [availableLots, setAvailableLots] = useState<DrugStock[]>([])
  const [submitting, setSubmitting] = useState(false)
  const [successMsg, setSuccessMsg] = useState('')
  const [errorMsg, setErrorMsg] = useState('')

  const supabase = createClient()

  useEffect(() => {
    supabase
      .from('pharmacy_drugs')
      .select('*')
      .eq('is_active', true)
      .order('system')
      .order('name')
      .then(({ data }: { data: PharmacyDrug[] | null }) => setDrugs(data ?? []))
  }, [])

  const filteredDrugs = drugs.filter(d =>
    d.name.toLowerCase().includes(search.toLowerCase()) ||
    (d.generic_name ?? '').toLowerCase().includes(search.toLowerCase())
  )

  async function selectDrug(drug: PharmacyDrug) {
    setSelectedDrug(drug)
    setForm(prev => ({ ...prev, drug_id: drug.id, quantity: '' }))
    setSearch(drug.name)
    setShowDropdown(false)

    // Load available lots (FEFO: order by expiry_date ASC, exclude expired lots with 0 qty)
    const { data } = await supabase
      .from('pharmacy_stock')
      .select('*')
      .eq('drug_id', drug.id)
      .gt('quantity', 0)
      .order('expiry_date', { ascending: true })

    setAvailableLots(data ?? [])
  }

  function handleChange(field: keyof DispenseForm, value: string) {
    setForm(prev => ({ ...prev, [field]: value }))
  }

  const totalAvailable = availableLots.reduce((sum, l) => sum + l.quantity, 0)
  const requestedQty = parseInt(form.quantity) || 0

  // Preview FEFO allocation
  function previewFEFO(qty: number): { lot: DrugStock; take: number }[] {
    const result: { lot: DrugStock; take: number }[] = []
    let remaining = qty
    for (const lot of availableLots) {
      if (remaining <= 0) break
      if (isExpired(lot.expiry_date)) continue // skip expired lots
      const take = Math.min(lot.quantity, remaining)
      result.push({ lot, take })
      remaining -= take
    }
    return result
  }

  const fefoPreview = requestedQty > 0 ? previewFEFO(requestedQty) : []
  const fefoTotal = fefoPreview.reduce((s, r) => s + r.take, 0)

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setErrorMsg('')
    setSuccessMsg('')

    if (!form.drug_id) { setErrorMsg('กรุณาเลือกยา'); return }
    if (!requestedQty || requestedQty <= 0) { setErrorMsg('จำนวนต้องมากกว่า 0'); return }

    // Check available non-expired stock
    const validLots = availableLots.filter(l => !isExpired(l.expiry_date))
    const validTotal = validLots.reduce((s, l) => s + l.quantity, 0)

    if (requestedQty > validTotal) {
      setErrorMsg(`Stock ไม่เพียงพอ — มียาที่ไม่หมดอายุเพียง ${validTotal} ${selectedDrug?.unit}`)
      return
    }

    if (!form.reference.trim()) {
      if (!confirm('ไม่มีเลข HN / อ้างอิง ยืนยันจ่ายยาหรือไม่?')) return
    }

    setSubmitting(true)
    try {
      let remaining = requestedQty

      for (const lot of availableLots) {
        if (remaining <= 0) break
        if (isExpired(lot.expiry_date)) continue

        const take = Math.min(lot.quantity, remaining)

        // Update lot quantity
        const { error: updateErr } = await supabase
          .from('pharmacy_stock')
          .update({ quantity: lot.quantity - take })
          .eq('id', lot.id)

        if (updateErr) throw updateErr

        // Record transaction per lot
        const { error: txErr } = await supabase
          .from('pharmacy_transactions')
          .insert({
            drug_id: form.drug_id,
            drug_lot_id: lot.id,
            transaction_type: 'dispense',
            quantity: -take,
            reference: form.reference.trim() || null,
            notes: form.notes.trim() || null,
            performed_by: form.performed_by.trim() || 'staff',
          })

        if (txErr) throw txErr

        remaining -= take
      }

      setSuccessMsg(`✅ จ่ายยา "${selectedDrug?.name}" ${requestedQty} ${selectedDrug?.unit} สำเร็จ`)
      setForm(emptyForm)
      setSearch('')
      setSelectedDrug(null)
      setAvailableLots([])
      setTimeout(() => setSuccessMsg(''), 5000)
    } catch (err: unknown) {
      setErrorMsg(`เกิดข้อผิดพลาด: ${err instanceof Error ? err.message : 'กรุณาลองใหม่'}`)
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <div className="max-w-2xl mx-auto space-y-6">
      {/* Page Title */}
      <div>
        <h1 className="text-2xl font-bold text-gray-900">📤 จ่ายยาออกจากคลัง</h1>
        <p className="text-gray-500 text-sm mt-1">ระบบจะตัดยาโดยใช้หลัก FEFO (หมดก่อน–จ่ายก่อน) อัตโนมัติ</p>
      </div>

      {/* Success / Error */}
      {successMsg && (
        <div className="bg-green-50 border border-green-200 text-green-800 rounded-xl px-4 py-3 flex items-center gap-2">
          <span className="text-xl">✅</span> {successMsg}
        </div>
      )}
      {errorMsg && (
        <div className="bg-red-50 border border-red-200 text-red-800 rounded-xl px-4 py-3 flex items-center gap-2">
          <span className="text-xl">❌</span> {errorMsg}
        </div>
      )}

      <form onSubmit={handleSubmit} className="bg-white rounded-xl border border-gray-200 shadow-sm p-6 space-y-5">

        {/* Drug Selector */}
        <div className="relative">
          <label className="block text-sm font-medium text-gray-700 mb-1.5">
            ชื่อยา <span className="text-red-500">*</span>
          </label>
          <input
            type="text"
            value={search}
            onChange={e => { setSearch(e.target.value); setShowDropdown(true); setSelectedDrug(null); setAvailableLots([]) }}
            onFocus={() => setShowDropdown(true)}
            placeholder="พิมพ์ชื่อยาหรือชื่อสามัญ..."
            className="w-full border border-gray-300 rounded-lg px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          {showDropdown && search && filteredDrugs.length > 0 && (
            <div className="absolute z-20 w-full mt-1 bg-white border border-gray-200 rounded-xl shadow-lg max-h-60 overflow-y-auto">
              {filteredDrugs.slice(0, 10).map(drug => (
                <button
                  key={drug.id}
                  type="button"
                  onClick={() => selectDrug(drug)}
                  className="w-full text-left px-4 py-3 hover:bg-blue-50 border-b border-gray-100 last:border-0 transition-colors"
                >
                  <div className="font-medium text-gray-800">{drug.name}</div>
                  <div className="text-xs text-gray-500">
                    {drug.generic_name && `${drug.generic_name} · `}
                    {drug.system} · {drug.unit}
                  </div>
                </button>
              ))}
            </div>
          )}
        </div>

        {/* Stock Summary */}
        {selectedDrug && (
          <div className={`rounded-lg px-4 py-3 text-sm border ${
            totalAvailable === 0 ? 'bg-red-50 border-red-200' :
            totalAvailable <= selectedDrug.min_stock ? 'bg-amber-50 border-amber-200' :
            'bg-green-50 border-green-200'
          }`}>
            <p className="font-semibold text-gray-800">{selectedDrug.name}</p>
            <p className={`font-bold text-lg ${
              totalAvailable === 0 ? 'text-red-600' :
              totalAvailable <= selectedDrug.min_stock ? 'text-amber-600' :
              'text-green-700'
            }`}>
              คงเหลือรวม: {totalAvailable} {selectedDrug.unit}
            </p>
            {totalAvailable <= selectedDrug.min_stock && totalAvailable > 0 && (
              <p className="text-amber-600 text-xs">⚠️ ต่ำกว่าขั้นต่ำ ({selectedDrug.min_stock} {selectedDrug.unit})</p>
            )}
          </div>
        )}

        {/* Quantity */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1.5">
            จำนวนจ่าย {selectedDrug && `(${selectedDrug.unit})`} <span className="text-red-500">*</span>
          </label>
          <input
            type="number"
            min="1"
            max={totalAvailable}
            value={form.quantity}
            onChange={e => handleChange('quantity', e.target.value)}
            placeholder="0"
            className="w-full border border-gray-300 rounded-lg px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>

        {/* FEFO Preview */}
        {fefoPreview.length > 0 && (
          <div className="bg-blue-50 border border-blue-200 rounded-lg p-3">
            <p className="text-xs font-semibold text-blue-700 uppercase tracking-wide mb-2">
              🔄 FEFO — ล็อตที่จะตัดออก
            </p>
            <div className="space-y-1">
              {fefoPreview.map(({ lot, take }) => (
                <div key={lot.id} className="flex items-center justify-between text-sm">
                  <span className="text-blue-800">Lot: {lot.lot_number} (หมดอายุ {formatDate(lot.expiry_date)})</span>
                  <span className="font-semibold text-blue-900">-{take} {selectedDrug?.unit}</span>
                </div>
              ))}
            </div>
            {fefoTotal < requestedQty && (
              <p className="text-red-600 text-xs mt-2 font-medium">
                ⛔ Stock ไม่พอ — จ่ายได้แค่ {fefoTotal} จาก {requestedQty} {selectedDrug?.unit}
              </p>
            )}
          </div>
        )}

        <div className="grid grid-cols-2 gap-4">
          {/* Reference (HN) */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1.5">เลข HN / อ้างอิง</label>
            <input
              type="text"
              value={form.reference}
              onChange={e => handleChange('reference', e.target.value)}
              placeholder="HN-12345678"
              className="w-full border border-gray-300 rounded-lg px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          {/* Performed by */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1.5">ผู้จ่ายยา</label>
            <input
              type="text"
              value={form.performed_by}
              onChange={e => handleChange('performed_by', e.target.value)}
              placeholder="ชื่อเภสัชกร/เจ้าหน้าที่"
              className="w-full border border-gray-300 rounded-lg px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>
        </div>

        {/* Notes */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1.5">หมายเหตุ</label>
          <input
            type="text"
            value={form.notes}
            onChange={e => handleChange('notes', e.target.value)}
            placeholder="หมายเหตุเพิ่มเติม (ถ้ามี)"
            className="w-full border border-gray-300 rounded-lg px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>

        <button
          type="submit"
          disabled={submitting || !selectedDrug || totalAvailable === 0 || fefoTotal < requestedQty || requestedQty === 0}
          className="w-full bg-blue-600 hover:bg-blue-700 disabled:bg-gray-300 disabled:cursor-not-allowed text-white font-semibold py-3 rounded-xl transition-colors text-lg"
        >
          {submitting ? '⏳ กำลังบันทึก...' : '📤 บันทึกจ่ายยาออก'}
        </button>
      </form>

      {/* Available Lots Table */}
      {availableLots.length > 0 && (
        <div className="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
          <div className="px-5 py-4 border-b border-gray-100 flex items-center justify-between">
            <h3 className="font-semibold text-gray-700">ล็อตที่มีในคลัง — เรียงตาม FEFO</h3>
            <span className="text-xs text-gray-400">หมดอายุก่อน → จ่ายก่อน</span>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead className="bg-gray-50 text-gray-600 text-xs uppercase">
                <tr>
                  <th className="text-left px-4 py-3">ลำดับ FEFO</th>
                  <th className="text-left px-4 py-3">Lot</th>
                  <th className="text-right px-4 py-3">คงเหลือ</th>
                  <th className="text-left px-4 py-3">หมดอายุ</th>
                  <th className="text-left px-4 py-3">สถานะ</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {availableLots.map((lot, idx) => {
                  const days = getDaysToExpiry(lot.expiry_date)
                  const expired = days < 0
                  return (
                    <tr key={lot.id} className={`${expired ? 'bg-red-50 opacity-60' : ''}`}>
                      <td className="px-4 py-2.5 text-gray-400 font-mono">
                        {expired ? '⛔' : `#${idx + 1}`}
                      </td>
                      <td className="px-4 py-2.5 font-mono text-gray-700">{lot.lot_number}</td>
                      <td className="px-4 py-2.5 text-right font-semibold">{lot.quantity}</td>
                      <td className="px-4 py-2.5 text-gray-600">{formatDate(lot.expiry_date)}</td>
                      <td className="px-4 py-2.5">
                        {expired ? (
                          <span className="text-xs bg-red-100 text-red-700 px-2 py-0.5 rounded-full">หมดอายุ (ข้าม)</span>
                        ) : days <= 30 ? (
                          <span className="text-xs bg-red-100 text-red-600 px-2 py-0.5 rounded-full">เหลือ {days} วัน</span>
                        ) : days <= 90 ? (
                          <span className="text-xs bg-amber-100 text-amber-700 px-2 py-0.5 rounded-full">เหลือ {days} วัน</span>
                        ) : (
                          <span className="text-xs bg-green-100 text-green-700 px-2 py-0.5 rounded-full">ปกติ</span>
                        )}
                      </td>
                    </tr>
                  )
                })}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </div>
  )
}
