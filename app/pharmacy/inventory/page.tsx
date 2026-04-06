'use client'

import { useEffect, useState, useCallback } from 'react'
import { createClient } from '@/lib/supabase/client'
import {
  type PharmacyDrug, type DrugStock, type DrugWithStock,
  DRUG_SYSTEMS, computeDrugWithStock, formatDate, getDaysToExpiry,
  getSystemColor, getSystemLabel,
} from '@/lib/pharmacy-types'

export default function InventoryPage() {
  const [drugs, setDrugs] = useState<DrugWithStock[]>([])
  const [loading, setLoading] = useState(true)
  const [filterSystem, setFilterSystem] = useState<string>('all')
  const [filterStatus, setFilterStatus] = useState<string>('all')
  const [searchQ, setSearchQ] = useState('')
  const [expandedDrug, setExpandedDrug] = useState<string | null>(null)
  const [lastUpdated, setLastUpdated] = useState<Date>(new Date())

  const supabase = createClient()

  const fetchData = useCallback(async () => {
    const [drugsRes, stocksRes] = await Promise.all([
      supabase.from('pharmacy_drugs').select('*').eq('is_active', true).order('system').order('name'),
      supabase.from('pharmacy_stock').select('*').order('expiry_date'),
    ])

    const drugList: PharmacyDrug[] = drugsRes.data ?? []
    const stockList: DrugStock[] = stocksRes.data ?? []

    setDrugs(drugList.map(d => computeDrugWithStock(d, stockList)))
    setLastUpdated(new Date())
    setLoading(false)
  }, [])

  useEffect(() => {
    fetchData()

    const channel = supabase
      .channel('pharmacy-inventory')
      .on('postgres_changes', { event: '*', schema: 'public', table: 'pharmacy_stock' }, fetchData)
      .on('postgres_changes', { event: '*', schema: 'public', table: 'pharmacy_drugs' }, fetchData)
      .subscribe()

    return () => { supabase.removeChannel(channel) }
  }, [fetchData])

  // Unique systems present in data
  const systems = Array.from(new Set(drugs.map(d => d.system)))

  // Filter drugs
  const filtered = drugs.filter(d => {
    if (filterSystem !== 'all' && d.system !== filterSystem) return false
    if (filterStatus === 'expired' && !d.has_expired) return false
    if (filterStatus === 'near_expiry' && !d.has_near_expiry) return false
    if (filterStatus === 'low_stock' && !d.is_low_stock) return false
    if (filterStatus === 'ok' && (d.has_expired || d.has_near_expiry || d.is_low_stock)) return false
    if (searchQ && !d.name.toLowerCase().includes(searchQ.toLowerCase()) &&
        !(d.generic_name ?? '').toLowerCase().includes(searchQ.toLowerCase())) return false
    return true
  })

  // Group by system
  const grouped = systems.reduce<Record<string, DrugWithStock[]>>((acc, sys) => {
    const list = filtered.filter(d => d.system === sys)
    if (list.length > 0) acc[sys] = list
    return acc
  }, {})

  function statusBadge(drug: DrugWithStock) {
    if (drug.total_stock === 0) {
      return <span className="text-xs bg-gray-100 text-gray-600 px-2 py-0.5 rounded-full font-medium">ไม่มีของ</span>
    }
    const badges = []
    if (drug.has_expired) {
      badges.push(<span key="exp" className="text-xs bg-red-100 text-red-700 px-2 py-0.5 rounded-full font-medium">🚨 หมดอายุ</span>)
    }
    if (drug.has_near_expiry && !drug.has_expired) {
      badges.push(<span key="near" className="text-xs bg-amber-100 text-amber-700 px-2 py-0.5 rounded-full font-medium">⚠️ ใกล้หมดอายุ</span>)
    }
    if (drug.is_low_stock) {
      badges.push(<span key="low" className="text-xs bg-orange-100 text-orange-700 px-2 py-0.5 rounded-full font-medium">📉 ของน้อย</span>)
    }
    if (badges.length === 0) {
      badges.push(<span key="ok" className="text-xs bg-green-100 text-green-700 px-2 py-0.5 rounded-full font-medium">✅ ปกติ</span>)
    }
    return <div className="flex flex-wrap gap-1">{badges}</div>
  }

  function rowBg(drug: DrugWithStock) {
    if (drug.has_expired) return 'bg-red-50 hover:bg-red-100'
    if (drug.has_near_expiry || drug.is_low_stock) return 'bg-amber-50 hover:bg-amber-100'
    return 'hover:bg-gray-50'
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-center">
          <div className="text-4xl mb-3 animate-pulse">📦</div>
          <p className="text-gray-500">กำลังโหลดข้อมูล...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between flex-wrap gap-3">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">📦 คลังยา</h1>
          <p className="text-sm text-gray-500 mt-0.5">
            อัปเดตล่าสุด: {lastUpdated.toLocaleTimeString('th-TH')}
            <span className="inline-block w-2 h-2 bg-green-400 rounded-full ml-2 animate-pulse" />
          </p>
        </div>
        <button onClick={fetchData} className="text-sm text-blue-600 hover:text-blue-800 border border-blue-200 rounded-lg px-3 py-1.5 hover:bg-blue-50 transition-colors">
          🔄 รีเฟรช
        </button>
      </div>

      {/* Filters */}
      <div className="bg-white rounded-xl border border-gray-200 shadow-sm p-4 flex flex-wrap gap-3 items-center">
        {/* Search */}
        <input
          type="text"
          value={searchQ}
          onChange={e => setSearchQ(e.target.value)}
          placeholder="🔍 ค้นหาชื่อยา..."
          className="border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 w-48"
        />

        {/* System filter */}
        <select
          value={filterSystem}
          onChange={e => setFilterSystem(e.target.value)}
          className="border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
        >
          <option value="all">ทุกระบบ</option>
          {systems.map(s => (
            <option key={s} value={s}>{getSystemLabel(s)}</option>
          ))}
        </select>

        {/* Status filter */}
        <select
          value={filterStatus}
          onChange={e => setFilterStatus(e.target.value)}
          className="border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
        >
          <option value="all">ทุกสถานะ</option>
          <option value="expired">🚨 หมดอายุ</option>
          <option value="near_expiry">⚠️ ใกล้หมดอายุ</option>
          <option value="low_stock">📉 ของน้อย</option>
          <option value="ok">✅ ปกติ</option>
        </select>

        <span className="text-sm text-gray-500 ml-auto">
          แสดง {filtered.length} / {drugs.length} รายการ
        </span>
      </div>

      {/* Summary Quick Stats */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
        {[
          { label: 'ทั้งหมด', count: drugs.length, color: 'border-gray-200 bg-white text-gray-700', icon: '💊' },
          { label: 'หมดอายุ', count: drugs.filter(d => d.has_expired).length, color: 'border-red-200 bg-red-50 text-red-700', icon: '🚨' },
          { label: 'ใกล้หมดอายุ', count: drugs.filter(d => d.has_near_expiry && !d.has_expired).length, color: 'border-amber-200 bg-amber-50 text-amber-700', icon: '⚠️' },
          { label: 'ของน้อย', count: drugs.filter(d => d.is_low_stock).length, color: 'border-orange-200 bg-orange-50 text-orange-700', icon: '📉' },
        ].map(s => (
          <button
            key={s.label}
            onClick={() => setFilterStatus(
              s.label === 'ทั้งหมด' ? 'all' :
              s.label === 'หมดอายุ' ? 'expired' :
              s.label === 'ใกล้หมดอายุ' ? 'near_expiry' : 'low_stock'
            )}
            className={`rounded-xl border p-4 text-left transition-all hover:shadow-md ${s.color}`}
          >
            <div className="text-2xl font-bold">{s.count}</div>
            <div className="text-xs mt-1">{s.icon} {s.label}</div>
          </button>
        ))}
      </div>

      {/* Drug Tables grouped by system */}
      {Object.keys(grouped).length === 0 ? (
        <div className="text-center py-12 text-gray-400">
          <div className="text-4xl mb-3">📭</div>
          <p>ไม่พบรายการยาที่ตรงกับเงื่อนไข</p>
        </div>
      ) : (
        Object.entries(grouped).map(([system, sysDrugs]) => (
          <div key={system} className="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
            {/* System header */}
            <div className="px-5 py-3 border-b border-gray-100 flex items-center gap-3 bg-gray-50">
              <span className={`text-xs font-semibold px-2.5 py-1 rounded-full ${getSystemColor(system)}`}>
                {getSystemLabel(system)}
              </span>
              <span className="text-sm text-gray-600">{sysDrugs.length} รายการ</span>
              <div className="flex gap-2 ml-auto text-xs">
                {sysDrugs.filter(d => d.has_expired).length > 0 && (
                  <span className="bg-red-100 text-red-600 px-1.5 py-0.5 rounded">🚨 {sysDrugs.filter(d => d.has_expired).length}</span>
                )}
                {sysDrugs.filter(d => d.is_low_stock).length > 0 && (
                  <span className="bg-orange-100 text-orange-600 px-1.5 py-0.5 rounded">📉 {sysDrugs.filter(d => d.is_low_stock).length}</span>
                )}
              </div>
            </div>

            {/* Table */}
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead className="text-gray-500 text-xs uppercase bg-gray-50/50">
                  <tr>
                    <th className="text-left px-4 py-3">ชื่อยา</th>
                    <th className="text-right px-4 py-3">คงเหลือ</th>
                    <th className="text-right px-4 py-3 hidden md:table-cell">ขั้นต่ำ</th>
                    <th className="text-left px-4 py-3 hidden md:table-cell">ที่เก็บ</th>
                    <th className="text-left px-4 py-3">สถานะ</th>
                    <th className="text-center px-4 py-3">รายละเอียด</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-100">
                  {sysDrugs.map(drug => (
                    <>
                      <tr key={drug.id} className={`transition-colors ${rowBg(drug)}`}>
                        <td className="px-4 py-3">
                          <div className="font-medium text-gray-800">{drug.name}</div>
                          {drug.generic_name && <div className="text-xs text-gray-400">{drug.generic_name}</div>}
                        </td>
                        <td className="px-4 py-3 text-right">
                          <span className={`font-bold text-base ${
                            drug.total_stock === 0 ? 'text-gray-400' :
                            drug.is_low_stock ? 'text-orange-600' : 'text-gray-800'
                          }`}>
                            {drug.total_stock}
                          </span>
                          <span className="text-xs text-gray-400 ml-1">{drug.unit}</span>
                        </td>
                        <td className="px-4 py-3 text-right text-gray-400 text-xs hidden md:table-cell">
                          {drug.min_stock} {drug.unit}
                        </td>
                        <td className="px-4 py-3 text-gray-500 text-xs hidden md:table-cell">
                          {drug.location ?? '—'}
                        </td>
                        <td className="px-4 py-3">
                          {statusBadge(drug)}
                        </td>
                        <td className="px-4 py-3 text-center">
                          <button
                            onClick={() => setExpandedDrug(expandedDrug === drug.id ? null : drug.id)}
                            className="text-xs text-blue-600 hover:text-blue-800 px-2 py-1 rounded hover:bg-blue-50 transition-colors"
                          >
                            {expandedDrug === drug.id ? '▲ ซ่อน' : '▼ ล็อต'}
                          </button>
                        </td>
                      </tr>

                      {/* Expanded lots */}
                      {expandedDrug === drug.id && (
                        <tr key={`${drug.id}-lots`}>
                          <td colSpan={6} className="px-4 py-3 bg-gray-50">
                            {drug.stocks.length === 0 ? (
                              <p className="text-sm text-gray-400 text-center py-2">ไม่มีของในคลัง</p>
                            ) : (
                              <table className="w-full text-xs">
                                <thead>
                                  <tr className="text-gray-500">
                                    <th className="text-left py-1 pr-4">Lot Number</th>
                                    <th className="text-right py-1 pr-4">จำนวน</th>
                                    <th className="text-left py-1 pr-4">หมดอายุ</th>
                                    <th className="text-left py-1 pr-4">ผู้จำหน่าย</th>
                                    <th className="text-left py-1">สถานะ</th>
                                  </tr>
                                </thead>
                                <tbody>
                                  {drug.stocks.map(lot => {
                                    const days = getDaysToExpiry(lot.expiry_date)
                                    return (
                                      <tr key={lot.id} className="border-t border-gray-200">
                                        <td className="font-mono py-1.5 pr-4 text-gray-700">{lot.lot_number}</td>
                                        <td className="text-right py-1.5 pr-4 font-semibold">{lot.quantity} {drug.unit}</td>
                                        <td className="py-1.5 pr-4 text-gray-600">{formatDate(lot.expiry_date)}</td>
                                        <td className="py-1.5 pr-4 text-gray-500">{lot.supplier ?? '—'}</td>
                                        <td className="py-1.5">
                                          {days < 0 ? (
                                            <span className="bg-red-100 text-red-700 px-1.5 py-0.5 rounded-full">หมดอายุ</span>
                                          ) : days <= 30 ? (
                                            <span className="bg-red-100 text-red-600 px-1.5 py-0.5 rounded-full">เหลือ {days} วัน</span>
                                          ) : days <= 90 ? (
                                            <span className="bg-amber-100 text-amber-700 px-1.5 py-0.5 rounded-full">เหลือ {days} วัน</span>
                                          ) : (
                                            <span className="bg-green-100 text-green-700 px-1.5 py-0.5 rounded-full">ปกติ</span>
                                          )}
                                        </td>
                                      </tr>
                                    )
                                  })}
                                </tbody>
                              </table>
                            )}
                          </td>
                        </tr>
                      )}
                    </>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        ))
      )}
    </div>
  )
}
