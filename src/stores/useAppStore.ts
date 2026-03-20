import { create } from 'zustand'
import { persist } from 'zustand/middleware'

export interface Component {
  id: string
  model: string
  brand: string
  platform: string
  package: string
  category: string
  platformId: string
  params: string
  price1: number
  price10: number
  price100: number
  price1000: number
  stock: number
  match: number
  link: string
  searchedAt: string
}

export interface SearchHistory {
  keyword: string
  time: string
  resultCount: number
}

interface AppState {
  // 搜索结果
  searchResults: Component[]
  setSearchResults: (results: Component[]) => void
  
  // 搜索历史
  searchHistory: SearchHistory[]
  addSearchHistory: (keyword: string, resultCount: number) => void
  clearSearchHistory: () => void
  
  // 收藏
  favorites: Component[]
  addToFavorites: (component: Component) => void
  removeFromFavorites: (id: string) => void
  clearFavorites: () => void
  
  // 搜索状态
  isSearching: boolean
  setIsSearching: (isSearching: boolean) => void
  
  // 当前搜索关键词
  currentKeyword: string
  setCurrentKeyword: (keyword: string) => void
  
  // 筛选条件
  filters: {
    brand: string
    package: string
    sort: 'platform' | 'price_asc' | 'price_desc' | 'stock'
  }
  setFilters: (filters: Partial<AppState['filters']>) => void
  
  // 统计
  stats: {
    totalSearches: number
    totalResults: number
    avgPrice: number
  }
  updateStats: () => void
}

export const useAppStore = create<AppState>()(
  persist(
    (set, get) => ({
      // 初始状态
      searchResults: [],
      searchHistory: [],
      favorites: [],
      isSearching: false,
      currentKeyword: '',
      filters: {
        brand: '',
        package: '',
        sort: 'platform',
      },
      stats: {
        totalSearches: 0,
        totalResults: 0,
        avgPrice: 0,
      },
      
      // 设置搜索结果
      setSearchResults: (results) => set({ searchResults: results }),
      
      // 添加搜索历史
      addSearchHistory: (keyword, resultCount) => set((state) => ({
        searchHistory: [
          { keyword, time: new Date().toLocaleString('zh-CN'), resultCount },
          ...state.searchHistory.slice(0, 49), // 保留最近50条
        ],
      })),
      
      // 清空搜索历史
      clearSearchHistory: () => set({ searchHistory: [] }),
      
      // 添加到收藏
      addToFavorites: (component) => set((state) => {
        const exists = state.favorites.find(f => f.id === component.id)
        if (exists) return state
        return {
          favorites: [{ ...component, searchedAt: new Date().toLocaleString('zh-CN') }, ...state.favorites],
        }
      }),
      
      // 从收藏移除
      removeFromFavorites: (id) => set((state) => ({
        favorites: state.favorites.filter(f => f.id !== id),
      })),
      
      // 清空收藏
      clearFavorites: () => set({ favorites: [] }),
      
      // 设置搜索状态
      setIsSearching: (isSearching) => set({ isSearching }),
      
      // 设置当前关键词
      setCurrentKeyword: (keyword) => set({ currentKeyword: keyword }),
      
      // 设置筛选条件
      setFilters: (filters) => set((state) => ({
        filters: { ...state.filters, ...filters },
      })),
      
      // 更新统计
      updateStats: () => set((state) => {
        const totalSearches = state.searchHistory.length
        const totalResults = state.searchHistory.reduce((sum, h) => sum + h.resultCount, 0)
        const avgPrice = state.favorites.length > 0
          ? state.favorites.reduce((sum, f) => sum + f.price1, 0) / state.favorites.length
          : 0
        
        return {
          stats: { totalSearches, totalResults, avgPrice },
        }
      }),
    }),
    {
      name: 'component-price-tool-storage',
      partialize: (state) => ({
        searchHistory: state.searchHistory,
        favorites: state.favorites,
      }),
    }
  )
)