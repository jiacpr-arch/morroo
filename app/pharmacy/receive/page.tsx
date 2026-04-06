'use client'

import { useEffect, useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import { type PharmacyDrug, type DrugStock, formatDate, getDaysToExpiry } from '@/lib/pharmacy-types'

interface ReceiveForm {
  drug_id: string
  lot_number: string
  quantity: string
  expiry_date: string
  supplier: string
  cost_per_unit: string
  notes: string
  performed_by: string
}

const emptyForm: ReceiveForm = {
  drug_id: '',
  lot_number: '',
  quantity: '',
  expiry_date: '',
  supplier: '',
  cost_per_unit: '',
  notes: '',
  performed_by: 'staff',
}

export default function ReceivePage() {
  const [drugs, setDrugs] = useState<PharmacyDrug[]>([])
  const [form, setForm] = useState<ReceiveForm>(emptyForm)
  const [search, setSearch] = useState('')
  const [showDropdown, setShowDropdown] = useState(false)
  const [selectedDrug, setSelectedDrug] = useState<PharmacyDrug | null>(null)
  const [existingLots, setExistingLots] = useState<DrugStock[]>([])
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
    setForm(prev => ({ ...prev, drug_id: drug.id }))
    setSearch(drug.name)
    setShowDropdown(false)

    // Load existing lots for this drug
    const { data } = await supabase
      .from('pharmacy_stock')
      .select('*')
      .eq('drug_id', drug.id)
      .order('expiry_date')
    setExistingLots(data ?? [])
  }

  function handleChange(field: keyof ReceiveForm, value: string) {
    setForm(prev => ({ ...prev, [field]: value }))
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setErrorMsg('')
    setSuccessMsg('')

    if (!form.drug_id) { setErrorMsg('กรุณาเลือกยา'); return }
    if (!form.lot_number.trim()) { setErrorMsg('กรุณากรอกเลข Lot'); return }
    if (!form.quantity || parseInt(form.quantity) <= 0) { setErrorMsg('จำนวนต้องมากกว่า 0'); return }
    if (!form.expiry_date) { setErrorMsg('กรุณาระบุวันหมดอายุ'); return }

    const daysLeft = getDaysToExpiry(form.expiry_date)
    if (daysLeft < 0) {
      setErrorMsg('วันหมดอายุต้องไม่ผ่านมาแล้ว')
      return
    }
    if (daysLeft < 30) {
      if (!confirm(`ยานี้จะหมดอายุในอีก ${daysLeft} วัน ยืนยันรับเข้าหรือไม่?`)) return
    }

    setSubmitting(true)
    try {
      const qty = parseInt(form.quantity)

      // Insert stock lot
      const { data: newStock, error: stockErr } = await supabase
        .from('pharmacy_stock')
        .insert({
          drug_id: form.drug_id,
          lot_number: form.lot_number.trim(),
          quantity: qty,
          expiry_date: form.expiry_date,
          supplier: form.supplier.trim() || null,
          cost_per_unit: form.cost_per_unit ? parseFloat(form.cost_per_unit) : null,
          notes: form.notes.trim() || null,
        })
        .select()
        .single()

      if (stockErr) throw stockErr

      // Record transaction
      await supabase.from('pharmacy_transactions').insert({
        drug_id: form.drug_id,
        drug_lot_id: newStock.id,
        transaction_type: 'receive',
        quantity: qty,
        notes: form.notes.trim() || null,
        performed_by: form.performed_by.trim() || 'staff',
      })

      setSuccessMsg(`✅ รับยา "${selectedDrug?.name}" เข้าคลัง ${qty} ${selectedDrug?.unit} สำเร็จ`)
      setForm(emptyForm)
      setSearch('')
      setSelectedDrug(null)
      setExistingLots([])

      setTimeout(() => setSuccessMsg(''), 5000)
    } catch (err: unknown) {
      setErrorMsg(`เกิดข้อผิดพลาด: ${err instanceof Error ? err.message : 'กรุณาลองใหม่'}`)
    } finally {
      setSubmitting(false)
    }
  }

  const expiryDays = form.expiry_date ? getDaysToExpiry(form.expiry_date) : null

  return (
    <div className="max-w-2xl mx-auto space-y-6">
      {/* Page Title */}
      <div>
        <h1 className="text-2xl font-bold text-gray-900">📥 รับยาเข้าคลัง</h1>
        <p className="text-gray-500 text-sm mt-1">บันทึกยาที่รับเข้าพร้อม Lot number และวันหมดอายุ</p>
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

      {/* Form */}
      <form onSubmit={handleSubmit} className="bg-white rounded-xl border border-gray-200 shadow-sm p-6 space-y-5">

        {/* Drug Selector */}
        <div className="relative">
          <label className="block text-sm font-medium text-gray-700 mb-1.5">
            ชื่อยา <span className="text-red-500">*</span>
          </label>
          <input
            type="text"
            value={search}
            onChange={e => { setSearch(e.target.value); setShowDropdown(true); setSelectedDrug(null) }}
            onFocus={() => setShowDropdown(true)}
            placeholder="พิมพ์ชื่อยาหรือชื่อสามัญ..."
            className="w-full border border-gray-300 rounded-lg px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
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
                    {drug.location && ` · ${drug.location}`}
                  </div>
                </button>
              ))}
            </div>
          )}
          {showDropdown && search && filteredDrugs.length === 0 && (
            <div className="absolute z-20 w-full mt-1 bg-white border border-gray-200 rounded-xl shadow-lg px-4 py-3 text-sm text-gray-400">
              ไม่พบยาที่ค้นหา
            </div>
          )}
        </div>

        {/* Selected Drug Info */}
        {selectedDrug && (
          <div className="bg-blue-50 border border-blue-200 rounded-lg px-4 py-3 text-sm">
            <p className="font-semibold text-blue-800">{selectedDrug.name}</p>
            <p className="text-blue-600">
              {selectedDrug.generic_name} · ระบบ: {selectedDrug.system} · หน่วย: {selectedDrug.unit}
              {selectedDrug.location && ` · ${selectedDrug.location}`}
            </p>
            <p className="text-blue-600">Stock ขั้นต่ำ: {selectedDrug.min_stock} {selectedDrug.unit}</p>
          </div>
        )}

        <div className="grid grid-cols-2 gap-4">
          {/* Lot Number */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1.5">
              เลข Lot <span className="text-red-500">*</span>
            </label>
            <input
              type="text"
              value={form.lot_number}
              onChange={e => handleChange('lot_number', e.target.value)}
              placeholder="เช่น PCM-2024-001"
              className="w-full border border-gray-300 rounded-lg px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          {/* Quantity */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1.5">
              จำนวนรับ {selectedDrug && `(${selectedDrug.unit})`} <span className="text-red-500">*</span>
            </label>
            <input
              type="number"
              min="1"
              value={form.quantity}
              onChange={e => handleChange('quantity', e.target.value)}
              placeholder="0"
              className="w-full border border-gray-300 rounded-lg px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>
        </div>

        {/* Expiry Date */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1.5">
            วันหมดอายุ <span className="text-red-500">*</span>
          </label>
          <input
            type="date"
            value={form.expiry_date}
            onChange={e => handleChange('expiry_date', e.target.value)}
            className="w-full border border-gray-300 rounded-lg px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          {expiryDays !== null && (
            <p className={`text-xs mt-1.5 font-medium ${
              expiryDays < 0 ? 'text-red-600' :
              expiryDays <= 30 ? 'text-red-500' :
              expiryDays <= 90 ? 'text-amber-500' :
              'text-green-600'
            }`}>
              {expiryDays < 0 ? `⛔ หมดอายุแล้ว ${Math.abs(expiryDays)} วัน` :
               expiryDays === 0 ? '⛔ หมดอายุวันนี้' :
               `เหลืออีก ${expiryDays} วัน`}
            </p>
          )}
        </div>

        <div className="grid grid-cols-2 gap-4">
          {/* Supplier */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1.5">ผู้จำหน่าย</label>
            <input
              type="text"
              value={form.supplier}
              onChange={e => handleChange('supplier', e.target.value)}
              placeholder="เช่น GPO, B.Braun"
              className="w-full border border-gray-300 rounded-lg px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          {/* Cost */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1.5">ราคาต่อหน่วย (บาท)</label>
            <input
              type="number"
              min="0"
              step="0.01"
              value={form.cost_per_unit}
              onChange={e => handleChange('cost_per_unit', e.target.value)}
              placeholder="0.00"
              className="w-full border border-gray-300 rounded-lg px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>
        </div>

        <div className="grid grid-cols-2 gap-4">
          {/* Performed by */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1.5">ผู้รับยา</label>
            <input
              type="text"
              value={form.performed_by}
              onChange={e => handleChange('performed_by', e.target.value)}
              placeholder="ชื่อเภสัชกร/เจ้าหน้าที่"
              className="w-full border border-gray-300 rounded-lg px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
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
        </div>

        <button
          type="submit"
          disabled={submitting || !selectedDrug}
          className="w-full bg-blue-600 hover:bg-blue-700 disabled:bg-gray-300 disabled:cursor-not-allowed text-white font-semibold py-3 rounded-xl transition-colors text-lg"
        >
          {submitting ? '⏳ กำลังบันทึก...' : '📥 บันทึกรับยาเข้า'}
        </button>
      </form>

      {/* Existing Lots */}
      {existingLots.length > 0 && (
        <div className="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
          <div className="px-5 py-4 border-b border-gray-100">
            <h3 className="font-semibold text-gray-700">ล็อตที่มีอยู่ในคลัง ({selectedDrug?.name})</h3>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead className="bg-gray-50 text-gray-600 text-xs uppercase">
                <tr>
                  <th className="text-left px-4 py-3">Lot</th>
                  <th className="text-right px-4 py-3">คงเหลือ</th>
                  <th className="text-left px-4 py-3">หมดอายุ</th>
                  <th className="text-left px-4 py-3">สถานะ</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {existingLots.map(lot => {
                  const days = getDaysToExpiry(lot.expiry_date)
                  return (
                    <tr key={lot.id} className={days < 0 ? 'bg-red-50' : days <= 90 ? 'bg-amber-50' : ''}>
                      <td className="px-4 py-2.5 font-mono text-gray-700">{lot.lot_number}</td>
                      <td className="px-4 py-2.5 text-right font-semibold">{lot.quantity}</td>
                      <td className="px-4 py-2.5 text-gray-600">{formatDate(lot.expiry_date)}</td>
                      <td className="px-4 py-2.5">
                        {days < 0 ? (
                          <span className="text-xs bg-red-100 text-red-700 px-2 py-0.5 rounded-full">หมดอายุ</span>
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
