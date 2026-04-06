'use client'

import { useEffect, useState, useCallback } from 'react'
import { createClient } from '@/lib/supabase/client'
import { type PharmacyDrug, DRUG_SYSTEMS, getSystemColor, getSystemLabel } from '@/lib/pharmacy-types'

interface DrugForm {
  name: string
  generic_name: string
  unit: string
  system: string
  min_stock: string
  location: string
  notes: string
}

const emptyForm: DrugForm = {
  name: '',
  generic_name: '',
  unit: 'เม็ด',
  system: 'OPD',
  min_stock: '10',
  location: '',
  notes: '',
}

const UNIT_OPTIONS = ['เม็ด', 'แคปซูล', 'ขวด', 'Amp', 'ซอง', 'หลอด', 'แผง', 'ชิ้น', 'ml', 'g']

export default function DrugsPage() {
  const [drugs, setDrugs] = useState<PharmacyDrug[]>([])
  const [loading, setLoading] = useState(true)
  const [showForm, setShowForm] = useState(false)
  const [editingDrug, setEditingDrug] = useState<PharmacyDrug | null>(null)
  const [form, setForm] = useState<DrugForm>(emptyForm)
  const [submitting, setSubmitting] = useState(false)
  const [successMsg, setSuccessMsg] = useState('')
  const [errorMsg, setErrorMsg] = useState('')
  const [searchQ, setSearchQ] = useState('')
  const [filterSystem, setFilterSystem] = useState('all')

  const supabase = createClient()

  const fetchDrugs = useCallback(async () => {
    const { data } = await supabase
      .from('pharmacy_drugs')
      .select('*')
      .order('system')
      .order('name')
    setDrugs(data ?? [])
    setLoading(false)
  }, [])

  useEffect(() => { fetchDrugs() }, [fetchDrugs])

  function openAdd() {
    setEditingDrug(null)
    setForm(emptyForm)
    setShowForm(true)
    setErrorMsg('')
    setSuccessMsg('')
  }

  function openEdit(drug: PharmacyDrug) {
    setEditingDrug(drug)
    setForm({
      name: drug.name,
      generic_name: drug.generic_name ?? '',
      unit: drug.unit,
      system: drug.system,
      min_stock: String(drug.min_stock),
      location: drug.location ?? '',
      notes: drug.notes ?? '',
    })
    setShowForm(true)
    setErrorMsg('')
    setSuccessMsg('')
  }

  function handleChange(field: keyof DrugForm, value: string) {
    setForm(prev => ({ ...prev, [field]: value }))
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setErrorMsg('')
    if (!form.name.trim()) { setErrorMsg('กรุณากรอกชื่อยา'); return }
    if (!form.min_stock || parseInt(form.min_stock) < 0) { setErrorMsg('Stock ขั้นต่ำต้องมากกว่า 0'); return }

    setSubmitting(true)
    try {
      const payload = {
        name: form.name.trim(),
        generic_name: form.generic_name.trim() || null,
        unit: form.unit,
        system: form.system,
        min_stock: parseInt(form.min_stock),
        location: form.location.trim() || null,
        notes: form.notes.trim() || null,
      }

      if (editingDrug) {
        const { error } = await supabase
          .from('pharmacy_drugs')
          .update({ ...payload, updated_at: new Date().toISOString() })
          .eq('id', editingDrug.id)
        if (error) throw error
        setSuccessMsg(`✅ แก้ไข "${form.name}" สำเร็จ`)
      } else {
        const { error } = await supabase
          .from('pharmacy_drugs')
          .insert(payload)
        if (error) throw error
        setSuccessMsg(`✅ เพิ่ม "${form.name}" สำเร็จ`)
      }

      setShowForm(false)
      fetchDrugs()
      setTimeout(() => setSuccessMsg(''), 4000)
    } catch (err: unknown) {
      setErrorMsg(`เกิดข้อผิดพลาด: ${err instanceof Error ? err.message : 'กรุณาลองใหม่'}`)
    } finally {
      setSubmitting(false)
    }
  }

  async function toggleActive(drug: PharmacyDrug) {
    const newState = !drug.is_active
    const action = newState ? 'เปิดใช้งาน' : 'ปิดใช้งาน'
    if (!confirm(`${action} "${drug.name}" หรือไม่?`)) return

    await supabase
      .from('pharmacy_drugs')
      .update({ is_active: newState, updated_at: new Date().toISOString() })
      .eq('id', drug.id)

    fetchDrugs()
  }

  const filtered = drugs.filter(d => {
    if (filterSystem !== 'all' && d.system !== filterSystem) return false
    if (searchQ && !d.name.toLowerCase().includes(searchQ.toLowerCase()) &&
        !(d.generic_name ?? '').toLowerCase().includes(searchQ.toLowerCase())) return false
    return true
  })

  const systems = Array.from(new Set(drugs.map(d => d.system)))

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between flex-wrap gap-3">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">💊 จัดการรายการยา</h1>
          <p className="text-gray-500 text-sm mt-0.5">เพิ่ม แก้ไข หรือปิดใช้งานรายการยาในระบบ</p>
        </div>
        <button
          onClick={openAdd}
          className="bg-blue-600 hover:bg-blue-700 text-white font-medium px-4 py-2.5 rounded-xl flex items-center gap-2 transition-colors"
        >
          ➕ เพิ่มยาใหม่
        </button>
      </div>

      {/* Success / Error (global) */}
      {successMsg && (
        <div className="bg-green-50 border border-green-200 text-green-800 rounded-xl px-4 py-3">{successMsg}</div>
      )}

      {/* Add/Edit Form */}
      {showForm && (
        <div className="bg-white rounded-xl border border-blue-200 shadow-md p-6 space-y-4">
          <h2 className="font-semibold text-gray-800 text-lg">
            {editingDrug ? '✏️ แก้ไขรายการยา' : '➕ เพิ่มยาใหม่'}
          </h2>

          {errorMsg && (
            <div className="bg-red-50 border border-red-200 text-red-700 rounded-lg px-3 py-2 text-sm">{errorMsg}</div>
          )}

          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  ชื่อยา (Trade name) <span className="text-red-500">*</span>
                </label>
                <input
                  type="text"
                  value={form.name}
                  onChange={e => handleChange('name', e.target.value)}
                  placeholder="เช่น Paracetamol 500mg"
                  className="w-full border border-gray-300 rounded-lg px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">ชื่อสามัญ (Generic)</label>
                <input
                  type="text"
                  value={form.generic_name}
                  onChange={e => handleChange('generic_name', e.target.value)}
                  placeholder="เช่น Paracetamol"
                  className="w-full border border-gray-300 rounded-lg px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">หน่วย <span className="text-red-500">*</span></label>
                <div className="flex gap-2">
                  <select
                    value={form.unit}
                    onChange={e => handleChange('unit', e.target.value)}
                    className="flex-1 border border-gray-300 rounded-lg px-3 py-2.5 focus:outline-none focus:ring-2 focus:ring-blue-500"
                  >
                    {UNIT_OPTIONS.map(u => <option key={u} value={u}>{u}</option>)}
                  </select>
                  <input
                    type="text"
                    value={form.unit}
                    onChange={e => handleChange('unit', e.target.value)}
                    placeholder="หน่วยอื่น"
                    className="w-28 border border-gray-300 rounded-lg px-3 py-2.5 focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                  />
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">ระบบ/หน่วยงาน <span className="text-red-500">*</span></label>
                <select
                  value={form.system}
                  onChange={e => handleChange('system', e.target.value)}
                  className="w-full border border-gray-300 rounded-lg px-3 py-2.5 focus:outline-none focus:ring-2 focus:ring-blue-500"
                >
                  {DRUG_SYSTEMS.map(s => (
                    <option key={s.value} value={s.value}>{s.label}</option>
                  ))}
                </select>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Stock ขั้นต่ำ ({form.unit}) <span className="text-red-500">*</span>
                </label>
                <input
                  type="number"
                  min="0"
                  value={form.min_stock}
                  onChange={e => handleChange('min_stock', e.target.value)}
                  placeholder="10"
                  className="w-full border border-gray-300 rounded-lg px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">ตำแหน่งจัดเก็บ</label>
                <input
                  type="text"
                  value={form.location}
                  onChange={e => handleChange('location', e.target.value)}
                  placeholder="เช่น ชั้น A1, ตู้เย็น B"
                  className="w-full border border-gray-300 rounded-lg px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">หมายเหตุ</label>
              <input
                type="text"
                value={form.notes}
                onChange={e => handleChange('notes', e.target.value)}
                placeholder="หมายเหตุ (ถ้ามี)"
                className="w-full border border-gray-300 rounded-lg px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>

            <div className="flex gap-3 pt-2">
              <button
                type="submit"
                disabled={submitting}
                className="flex-1 bg-blue-600 hover:bg-blue-700 disabled:bg-gray-300 text-white font-semibold py-2.5 rounded-xl transition-colors"
              >
                {submitting ? '⏳ กำลังบันทึก...' : editingDrug ? '💾 บันทึกการแก้ไข' : '➕ เพิ่มยา'}
              </button>
              <button
                type="button"
                onClick={() => setShowForm(false)}
                className="px-6 border border-gray-300 text-gray-600 hover:bg-gray-50 rounded-xl transition-colors"
              >
                ยกเลิก
              </button>
            </div>
          </form>
        </div>
      )}

      {/* Filters */}
      <div className="flex flex-wrap gap-3 items-center">
        <input
          type="text"
          value={searchQ}
          onChange={e => setSearchQ(e.target.value)}
          placeholder="🔍 ค้นหาชื่อยา..."
          className="border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 w-48"
        />
        <select
          value={filterSystem}
          onChange={e => setFilterSystem(e.target.value)}
          className="border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
        >
          <option value="all">ทุกระบบ</option>
          {systems.map(s => <option key={s} value={s}>{getSystemLabel(s)}</option>)}
        </select>
        <span className="text-sm text-gray-500 ml-auto">{filtered.length} รายการ</span>
      </div>

      {/* Drug List */}
      {loading ? (
        <div className="text-center py-12 text-gray-400">
          <div className="text-4xl mb-3 animate-pulse">💊</div>
          <p>กำลังโหลด...</p>
        </div>
      ) : (
        <div className="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead className="bg-gray-50 text-gray-500 text-xs uppercase">
                <tr>
                  <th className="text-left px-4 py-3">ชื่อยา</th>
                  <th className="text-left px-4 py-3 hidden md:table-cell">Generic</th>
                  <th className="text-left px-4 py-3">ระบบ</th>
                  <th className="text-left px-4 py-3 hidden md:table-cell">หน่วย</th>
                  <th className="text-right px-4 py-3 hidden md:table-cell">Stock ขั้นต่ำ</th>
                  <th className="text-left px-4 py-3 hidden lg:table-cell">ที่เก็บ</th>
                  <th className="text-center px-4 py-3">สถานะ</th>
                  <th className="text-center px-4 py-3">จัดการ</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {filtered.map(drug => (
                  <tr key={drug.id} className={`transition-colors ${drug.is_active ? 'hover:bg-gray-50' : 'opacity-50 bg-gray-50'}`}>
                    <td className="px-4 py-3">
                      <div className="font-medium text-gray-800">{drug.name}</div>
                    </td>
                    <td className="px-4 py-3 text-gray-500 hidden md:table-cell">{drug.generic_name ?? '—'}</td>
                    <td className="px-4 py-3">
                      <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${getSystemColor(drug.system)}`}>
                        {drug.system}
                      </span>
                    </td>
                    <td className="px-4 py-3 text-gray-500 hidden md:table-cell">{drug.unit}</td>
                    <td className="px-4 py-3 text-right text-gray-600 hidden md:table-cell">{drug.min_stock}</td>
                    <td className="px-4 py-3 text-gray-400 text-xs hidden lg:table-cell">{drug.location ?? '—'}</td>
                    <td className="px-4 py-3 text-center">
                      {drug.is_active ? (
                        <span className="text-xs bg-green-100 text-green-700 px-2 py-0.5 rounded-full">ใช้งาน</span>
                      ) : (
                        <span className="text-xs bg-gray-100 text-gray-500 px-2 py-0.5 rounded-full">ปิด</span>
                      )}
                    </td>
                    <td className="px-4 py-3 text-center">
                      <div className="flex items-center justify-center gap-1">
                        <button
                          onClick={() => openEdit(drug)}
                          className="text-xs text-blue-600 hover:text-blue-800 px-2 py-1 rounded hover:bg-blue-50 transition-colors"
                        >
                          ✏️
                        </button>
                        <button
                          onClick={() => toggleActive(drug)}
                          className={`text-xs px-2 py-1 rounded transition-colors ${
                            drug.is_active
                              ? 'text-red-500 hover:text-red-700 hover:bg-red-50'
                              : 'text-green-600 hover:text-green-800 hover:bg-green-50'
                          }`}
                        >
                          {drug.is_active ? '🔒' : '🔓'}
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
            {filtered.length === 0 && (
              <div className="text-center py-12 text-gray-400">
                <p>ไม่พบรายการยา</p>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  )
}
