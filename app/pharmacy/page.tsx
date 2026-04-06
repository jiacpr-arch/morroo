'use client'

import { useEffect, useState, useCallback } from 'react'
import { createClient } from '@/lib/supabase/client'
import {
  type PharmacyDrug, type DrugStock, type TransactionWithDrug,
  type DrugWithStock, type ExpiredAlert, type NearExpiryAlert, type LowStockAlert,
  computeDrugWithStock, buildAlerts, formatDate, formatDateTime, getSystemColor, getSystemLabel,
} from '@/lib/pharmacy-types'

// ──────────────────────────────────────────
// Stat Card
// ──────────────────────────────────────────
function StatCard({ label, value, icon, color }: { label: string; value: number; icon: string; color: string }) {
  return (
    <div className={`rounded-xl p-5 shadow-sm border ${color}`}>
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm font-medium opacity-70">{label}</p>
          <p className="text-3xl font-bold mt-1">{value}</p>
        </div>
        <span className="text-4xl">{icon}</span>
      </div>
    </div>
  )
}

// ──────────────────────────────────────────
// Alert Section
// ──────────────────────────────────────────
function AlertSection({
  expired, nearExpiry, lowStock
}: {
  expired: ExpiredAlert[]
  nearExpiry: NearExpiryAlert[]
  lowStock: LowStockAlert[]
}) {
  if (expired.length === 0 && nearExpiry.length === 0 && lowStock.length === 0) {
    return (
      <div className="bg-green-50 border border-green-200 rounded-xl p-6 flex items-center gap-3">
        <span className="text-3xl">✅</span>
        <div>
          <p className="font-semibold text-green-800">คลังยาปกติทุกรายการ</p>
          <p className="text-green-600 text-sm">ไม่มีการแจ้งเตือนใดๆ</p>
        </div>
      </div>
    )
  }

  return (
    <div className="space-y-4">
      {/* Expired */}
      {expired.length > 0 && (
        <div className="bg-red-50 border border-red-200 rounded-xl overflow-hidden">
          <div className="bg-red-600 text-white px-4 py-3 flex items-center gap-2">
            <span className="text-xl">🚨</span>
            <span className="font-semibold">ยาหมดอายุแล้ว — {expired.length} รายการ</span>
          </div>
          <div className="divide-y divide-red-100">
            {expired.map(({ drug, lot, days_past }) => (
              <div key={lot.id} className="px-4 py-3 flex items-center justify-between">
                <div>
                  <p className="font-medium text-red-900">{drug.name}</p>
                  <p className="text-sm text-red-600">
                    Lot: {lot.lot_number} · หมดอายุเมื่อ {formatDate(lot.expiry_date)} ({days_past} วันที่แล้ว)
                  </p>
                </div>
                <div className="text-right">
                  <span className="bg-red-100 text-red-700 px-2 py-1 rounded-full text-sm font-medium">
                    คงเหลือ {lot.quantity} {drug.unit}
                  </span>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Near Expiry */}
      {nearExpiry.length > 0 && (
        <div className="bg-amber-50 border border-amber-200 rounded-xl overflow-hidden">
          <div className="bg-amber-500 text-white px-4 py-3 flex items-center gap-2">
            <span className="text-xl">⚠️</span>
            <span className="font-semibold">ยาใกล้หมดอายุ (ภายใน 90 วัน) — {nearExpiry.length} รายการ</span>
          </div>
          <div className="divide-y divide-amber-100">
            {nearExpiry.map(({ drug, lot, days_left }) => (
              <div key={lot.id} className="px-4 py-3 flex items-center justify-between">
                <div>
                  <p className="font-medium text-amber-900">{drug.name}</p>
                  <p className="text-sm text-amber-700">
                    Lot: {lot.lot_number} · หมดอายุ {formatDate(lot.expiry_date)}
                  </p>
                </div>
                <div className="text-right space-y-1">
                  <div>
                    <span className={`px-2 py-1 rounded-full text-sm font-bold ${
                      days_left <= 30 ? 'bg-red-100 text-red-700' : 'bg-amber-100 text-amber-700'
                    }`}>
                      เหลือ {days_left} วัน
                    </span>
                  </div>
                  <div className="text-xs text-amber-600">{lot.quantity} {drug.unit}</div>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Low Stock */}
      {lowStock.length > 0 && (
        <div className="bg-orange-50 border border-orange-200 rounded-xl overflow-hidden">
          <div className="bg-orange-500 text-white px-4 py-3 flex items-center gap-2">
            <span className="text-xl">📉</span>
            <span className="font-semibold">ยาใกล้หมด (ต่ำกว่าขั้นต่ำ) — {lowStock.length} รายการ</span>
          </div>
          <div className="divide-y divide-orange-100">
            {lowStock.map(({ drug, total_stock }) => (
              <div key={drug.id} className="px-4 py-3 flex items-center justify-between">
                <div>
                  <p className="font-medium text-orange-900">{drug.name}</p>
                  <p className="text-sm text-orange-600">
                    ระบบ: {getSystemLabel(drug.system)}
                    {drug.location && ` · ${drug.location}`}
                  </p>
                </div>
                <div className="text-right">
                  <span className="bg-orange-100 text-orange-700 px-2 py-1 rounded-full text-sm font-medium">
                    {total_stock} / {drug.min_stock} {drug.unit}
                  </span>
                  <p className="text-xs text-orange-500 mt-1">คงเหลือ / ขั้นต่ำ</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  )
}

// ──────────────────────────────────────────
// Recent Transactions Table
// ──────────────────────────────────────────
function RecentTransactions({ transactions }: { transactions: TransactionWithDrug[] }) {
  return (
    <div className="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
      <div className="px-5 py-4 border-b border-gray-100 flex items-center gap-2">
        <span className="text-lg">📋</span>
        <h2 className="font-semibold text-gray-800">รายการล่าสุด</h2>
      </div>
      {transactions.length === 0 ? (
        <p className="text-center text-gray-400 py-8">ยังไม่มีรายการ</p>
      ) : (
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead className="bg-gray-50 text-gray-600 text-xs uppercase tracking-wide">
              <tr>
                <th className="text-left px-4 py-3">เวลา</th>
                <th className="text-left px-4 py-3">ประเภท</th>
                <th className="text-left px-4 py-3">ชื่อยา</th>
                <th className="text-right px-4 py-3">จำนวน</th>
                <th className="text-left px-4 py-3">อ้างอิง</th>
                <th className="text-left px-4 py-3">ผู้ดำเนินการ</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {transactions.map(tx => (
                <tr key={tx.id} className="hover:bg-gray-50 transition-colors">
                  <td className="px-4 py-3 text-gray-500 whitespace-nowrap">
                    {formatDateTime(tx.created_at)}
                  </td>
                  <td className="px-4 py-3">
                    {tx.transaction_type === 'receive' ? (
                      <span className="inline-flex items-center gap-1 bg-green-100 text-green-700 px-2 py-0.5 rounded-full text-xs font-medium">
                        📥 รับเข้า
                      </span>
                    ) : tx.transaction_type === 'dispense' ? (
                      <span className="inline-flex items-center gap-1 bg-blue-100 text-blue-700 px-2 py-0.5 rounded-full text-xs font-medium">
                        📤 จ่ายออก
                      </span>
                    ) : (
                      <span className="inline-flex items-center gap-1 bg-gray-100 text-gray-700 px-2 py-0.5 rounded-full text-xs font-medium">
                        🔄 ปรับ
                      </span>
                    )}
                  </td>
                  <td className="px-4 py-3 font-medium text-gray-800">
                    {tx.pharmacy_drugs?.name ?? '—'}
                  </td>
                  <td className={`px-4 py-3 text-right font-semibold ${
                    tx.quantity > 0 ? 'text-green-600' : 'text-red-600'
                  }`}>
                    {tx.quantity > 0 ? '+' : ''}{tx.quantity} {tx.pharmacy_drugs?.unit}
                  </td>
                  <td className="px-4 py-3 text-gray-500">{tx.reference ?? '—'}</td>
                  <td className="px-4 py-3 text-gray-500">{tx.performed_by ?? 'staff'}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  )
}

// ──────────────────────────────────────────
// Main Dashboard Page
// ──────────────────────────────────────────
export default function PharmacyDashboard() {
  const [drugs, setDrugs] = useState<DrugWithStock[]>([])
  const [transactions, setTransactions] = useState<TransactionWithDrug[]>([])
  const [loading, setLoading] = useState(true)
  const [lastUpdated, setLastUpdated] = useState<Date>(new Date())

  const supabase = createClient()

  const fetchData = useCallback(async () => {
    const [drugsRes, stocksRes, txRes] = await Promise.all([
      supabase.from('pharmacy_drugs').select('*').eq('is_active', true).order('system').order('name'),
      supabase.from('pharmacy_stock').select('*'),
      supabase
        .from('pharmacy_transactions')
        .select('*, pharmacy_drugs(name, unit)')
        .order('created_at', { ascending: false })
        .limit(20),
    ])

    const drugList: PharmacyDrug[] = drugsRes.data ?? []
    const stockList: DrugStock[] = stocksRes.data ?? []

    const enriched = drugList.map(d => computeDrugWithStock(d, stockList))
    setDrugs(enriched)
    setTransactions((txRes.data ?? []) as TransactionWithDrug[])
    setLastUpdated(new Date())
    setLoading(false)
  }, [])

  useEffect(() => {
    fetchData()

    // Real-time subscription
    const channel = supabase
      .channel('pharmacy-dashboard')
      .on('postgres_changes', { event: '*', schema: 'public', table: 'pharmacy_stock' }, fetchData)
      .on('postgres_changes', { event: '*', schema: 'public', table: 'pharmacy_transactions' }, fetchData)
      .on('postgres_changes', { event: '*', schema: 'public', table: 'pharmacy_drugs' }, fetchData)
      .subscribe()

    return () => { supabase.removeChannel(channel) }
  }, [fetchData])

  const { expired, nearExpiry, lowStock } = buildAlerts(drugs)
  const totalAlerts = expired.length + nearExpiry.length + lowStock.length

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-center">
          <div className="text-4xl mb-3 animate-pulse">💊</div>
          <p className="text-gray-500">กำลังโหลดข้อมูล...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      {/* Page header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">แดชบอร์ด</h1>
          <p className="text-sm text-gray-500 mt-0.5">
            อัปเดตล่าสุด: {lastUpdated.toLocaleTimeString('th-TH')}
            <span className="inline-block w-2 h-2 bg-green-400 rounded-full ml-2 animate-pulse" />
          </p>
        </div>
        <button
          onClick={fetchData}
          className="text-sm text-blue-600 hover:text-blue-800 flex items-center gap-1 border border-blue-200 rounded-lg px-3 py-1.5 hover:bg-blue-50 transition-colors"
        >
          🔄 รีเฟรช
        </button>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <StatCard
          label="รายการยาทั้งหมด"
          value={drugs.length}
          icon="💊"
          color="bg-white border-gray-200 text-gray-800"
        />
        <StatCard
          label="ยาหมดอายุ"
          value={expired.length}
          icon="🚨"
          color={expired.length > 0 ? 'bg-red-50 border-red-200 text-red-800' : 'bg-white border-gray-200 text-gray-800'}
        />
        <StatCard
          label="ใกล้หมดอายุ"
          value={nearExpiry.length}
          icon="⚠️"
          color={nearExpiry.length > 0 ? 'bg-amber-50 border-amber-200 text-amber-800' : 'bg-white border-gray-200 text-gray-800'}
        />
        <StatCard
          label="ยาใกล้หมด"
          value={lowStock.length}
          icon="📉"
          color={lowStock.length > 0 ? 'bg-orange-50 border-orange-200 text-orange-800' : 'bg-white border-gray-200 text-gray-800'}
        />
      </div>

      {/* Alert Banner when there are alerts */}
      {totalAlerts > 0 && (
        <div className="bg-red-600 text-white rounded-xl px-5 py-3 flex items-center gap-3">
          <span className="text-2xl">🔔</span>
          <p className="font-semibold">
            มีการแจ้งเตือน {totalAlerts} รายการ — กรุณาตรวจสอบและดำเนินการ
          </p>
        </div>
      )}

      {/* Alerts */}
      <div>
        <h2 className="text-lg font-semibold text-gray-800 mb-3 flex items-center gap-2">
          🔔 การแจ้งเตือน
        </h2>
        <AlertSection expired={expired} nearExpiry={nearExpiry} lowStock={lowStock} />
      </div>

      {/* Stock by System Summary */}
      <div>
        <h2 className="text-lg font-semibold text-gray-800 mb-3">📊 สรุปตามระบบ</h2>
        <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-3">
          {['OPD', 'IPD', 'ER', 'ICU', 'OR', 'กุมารฯ', 'ทั่วไป'].map(system => {
            const systemDrugs = drugs.filter(d => d.system === system)
            if (systemDrugs.length === 0) return null
            const issues = systemDrugs.filter(d => d.has_expired || d.has_near_expiry || d.is_low_stock)
            return (
              <div key={system} className="bg-white rounded-xl border border-gray-200 p-4 shadow-sm">
                <div className="flex items-center justify-between mb-2">
                  <span className={`text-xs font-semibold px-2 py-0.5 rounded-full ${getSystemColor(system)}`}>
                    {system}
                  </span>
                  {issues.length > 0 && (
                    <span className="text-xs bg-red-100 text-red-600 px-1.5 py-0.5 rounded-full font-medium">
                      ⚠️ {issues.length}
                    </span>
                  )}
                </div>
                <p className="text-2xl font-bold text-gray-800">{systemDrugs.length}</p>
                <p className="text-xs text-gray-500">รายการยา</p>
              </div>
            )
          })}
        </div>
      </div>

      {/* Recent Transactions */}
      <RecentTransactions transactions={transactions} />
    </div>
  )
}
