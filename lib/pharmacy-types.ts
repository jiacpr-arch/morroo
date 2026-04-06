// ============================================================
// Pharmacy Management System — Types & Utilities
// ============================================================

export const DRUG_SYSTEMS = [
  { value: 'OPD', label: 'ผู้ป่วยนอก (OPD)', color: 'bg-blue-100 text-blue-700' },
  { value: 'IPD', label: 'ผู้ป่วยใน (IPD)', color: 'bg-purple-100 text-purple-700' },
  { value: 'ER', label: 'ห้องฉุกเฉิน (ER)', color: 'bg-red-100 text-red-700' },
  { value: 'ICU', label: 'หน่วยวิกฤต (ICU)', color: 'bg-orange-100 text-orange-700' },
  { value: 'OR', label: 'ห้องผ่าตัด (OR)', color: 'bg-green-100 text-green-700' },
  { value: 'กุมารฯ', label: 'กุมารเวชศาสตร์', color: 'bg-pink-100 text-pink-700' },
  { value: 'ทั่วไป', label: 'ทั่วไป', color: 'bg-gray-100 text-gray-700' },
] as const

export type DrugSystemValue = typeof DRUG_SYSTEMS[number]['value']

export function getSystemLabel(system: string) {
  return DRUG_SYSTEMS.find(s => s.value === system)?.label ?? system
}

export function getSystemColor(system: string) {
  return DRUG_SYSTEMS.find(s => s.value === system)?.color ?? 'bg-gray-100 text-gray-700'
}

// ──────────────────────────────────────────
// Database row types
// ──────────────────────────────────────────

export interface PharmacyDrug {
  id: string
  name: string
  generic_name?: string | null
  unit: string
  system: string
  min_stock: number
  location?: string | null
  notes?: string | null
  is_active: boolean
  created_at: string
  updated_at: string
}

export interface DrugStock {
  id: string
  drug_id: string
  lot_number: string
  quantity: number
  expiry_date: string       // ISO date string 'YYYY-MM-DD'
  supplier?: string | null
  cost_per_unit?: number | null
  received_at: string
  notes?: string | null
}

export interface DrugTransaction {
  id: string
  drug_id: string
  drug_lot_id?: string | null
  transaction_type: 'receive' | 'dispense' | 'adjust' | 'return'
  quantity: number          // positive=รับเข้า, negative=จ่ายออก
  reference?: string | null
  notes?: string | null
  performed_by?: string | null
  created_at: string
}

// Transaction enriched with drug info (from join)
export interface TransactionWithDrug extends DrugTransaction {
  pharmacy_drugs?: { name: string; unit: string } | null
}

// ──────────────────────────────────────────
// Computed / enriched types
// ──────────────────────────────────────────

export interface DrugWithStock extends PharmacyDrug {
  stocks: DrugStock[]
  total_stock: number
  has_expired: boolean         // มีล็อตที่หมดอายุและยังมีของอยู่
  has_near_expiry: boolean     // มีล็อตที่จะหมดอายุใน 90 วัน
  is_low_stock: boolean        // total_stock <= min_stock
  min_days_to_expiry: number | null
}

export interface ExpiredAlert {
  drug: PharmacyDrug
  lot: DrugStock
  days_past: number
}

export interface NearExpiryAlert {
  drug: PharmacyDrug
  lot: DrugStock
  days_left: number
}

export interface LowStockAlert {
  drug: PharmacyDrug
  total_stock: number
}

// ──────────────────────────────────────────
// Helper functions
// ──────────────────────────────────────────

export const NEAR_EXPIRY_DAYS = 90

export function getDaysToExpiry(expiryDate: string): number {
  const today = new Date()
  today.setHours(0, 0, 0, 0)
  const expiry = new Date(expiryDate)
  expiry.setHours(0, 0, 0, 0)
  return Math.ceil((expiry.getTime() - today.getTime()) / (1000 * 60 * 60 * 24))
}

export function isExpired(expiryDate: string): boolean {
  return getDaysToExpiry(expiryDate) < 0
}

export function isNearExpiry(expiryDate: string): boolean {
  const days = getDaysToExpiry(expiryDate)
  return days >= 0 && days <= NEAR_EXPIRY_DAYS
}

export function formatDate(dateStr: string): string {
  const d = new Date(dateStr)
  return d.toLocaleDateString('th-TH', { day: '2-digit', month: '2-digit', year: 'numeric' })
}

export function formatDateTime(dateStr: string): string {
  const d = new Date(dateStr)
  return d.toLocaleString('th-TH', {
    day: '2-digit', month: '2-digit', year: 'numeric',
    hour: '2-digit', minute: '2-digit',
  })
}

export function computeDrugWithStock(drug: PharmacyDrug, stocks: DrugStock[]): DrugWithStock {
  const activeStocks = stocks.filter(s => s.drug_id === drug.id && s.quantity > 0)
  const total_stock = activeStocks.reduce((sum, s) => sum + s.quantity, 0)

  const has_expired = activeStocks.some(s => isExpired(s.expiry_date))

  const nearExpiryStocks = activeStocks.filter(s => isNearExpiry(s.expiry_date))
  const has_near_expiry = nearExpiryStocks.length > 0

  const validDays = activeStocks
    .map(s => getDaysToExpiry(s.expiry_date))
    .filter(d => d >= 0)
  const min_days_to_expiry = validDays.length > 0 ? Math.min(...validDays) : null

  return {
    ...drug,
    stocks: activeStocks,
    total_stock,
    has_expired,
    has_near_expiry,
    is_low_stock: total_stock <= drug.min_stock,
    min_days_to_expiry,
  }
}

export function buildAlerts(drugsWithStock: DrugWithStock[]) {
  const expired: ExpiredAlert[] = []
  const nearExpiry: NearExpiryAlert[] = []
  const lowStock: LowStockAlert[] = []

  for (const drug of drugsWithStock) {
    for (const lot of drug.stocks) {
      const days = getDaysToExpiry(lot.expiry_date)
      if (days < 0) {
        expired.push({ drug, lot, days_past: Math.abs(days) })
      } else if (days <= NEAR_EXPIRY_DAYS) {
        nearExpiry.push({ drug, lot, days_left: days })
      }
    }
    if (drug.is_low_stock) {
      lowStock.push({ drug, total_stock: drug.total_stock })
    }
  }

  // Sort by urgency
  expired.sort((a, b) => b.days_past - a.days_past)
  nearExpiry.sort((a, b) => a.days_left - b.days_left)
  lowStock.sort((a, b) => a.total_stock - b.total_stock)

  return { expired, nearExpiry, lowStock }
}
