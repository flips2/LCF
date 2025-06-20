export interface User {
  id: string;
  email: string;
  created_at: string;
  user_metadata?: {
    username?: string;
    display_name?: string;
  };
}

export interface TradingSession {
  id: string;
  user_id: string;
  name: string;
  initial_capital: number;
  current_capital: number;
  created_at: string;
  updated_at: string;
}

export interface Trade {
  id: string;
  session_id: string;
  margin: number;
  roi: number;
  entry_side: 'Long' | 'Short';
  profit_loss: number;
  comments?: string;
  created_at: string;
  // Enhanced fields for advanced trade tracking
  symbol?: string;
  volume_lot?: number;
  open_price?: number;
  close_price?: number;
  tp?: number;
  sl?: number;
  position?: 'Open' | 'Closed';
  open_time?: string;
  close_time?: string;
  reason?: 'TP' | 'SL' | 'Early Close' | 'Other';
}

export interface SessionStats {
  totalTrades: number;
  winRate: number;
  currentCapital: number;
  netProfitLoss: number;
  netProfitLossPercentage: number;
  totalMarginUsed: number;
  averageROI: number;
  winningTrades: number;
  losingTrades: number;
}

export interface QuoteResponse {
  content: string;
  author: string;
}

// Enhanced Analytics Types
export interface UserAnalytics {
  sharpeRatio: number;
  maxDrawdown: {
    percentage: number;
    amount: number;
  };
  profitFactor: number;
  averageRMultiple: number;
  activeCapital: number;
  tradeDistribution: {
    longTrades: number;
    shortTrades: number;
    longPercentage: number;
    shortPercentage: number;
  };
  timeAnalysis: {
    avgHoldTime: number;
    bestTime: string;
  };
  riskMetrics: {
    avgRiskPerTrade: number;
    maxRisk: number;
  };
  streaks: {
    bestStreak: number;
    worstStreak: number;
  };
  overallPerformance: number;
  successRate: number;
  riskLevel: 'Low' | 'Moderate' | 'High';
}

// Market Data Types
export interface CryptoPrice {
  symbol: string;
  price: number;
  change24h: number;
  changePercent24h: number;
}

export interface GoldPrice {
  price: number;
  change24h: number;
  changePercent24h: number;
}

export interface FearGreedIndex {
  value: number;
  classification: string;
  timestamp: string;
}

export interface NewsItem {
  title: string;
  summary: string;
  url: string;
  publishedAt: string;
  source: string;
}

export interface MarketData {
  crypto: {
    btc: CryptoPrice;
    eth: CryptoPrice;
  };
  gold: GoldPrice;
  fearGreed: FearGreedIndex;
  news: NewsItem[];
}

// Chat Types
export interface ChatMessage {
  id: string;
  user_id: string;
  message: string;
  response?: string;
  message_type: 'user' | 'ai';
  created_at: string;
}

// Trade Extraction Types
export interface ExtractedTradeData {
  symbol?: string;
  type?: string;
  volumeLot?: number;
  openPrice?: number;
  closePrice?: number;
  tp?: number;
  sl?: number;
  position?: string;
  openTime?: string;
  closeTime?: string;
  reason?: string;
  pnlUsd?: number;
}