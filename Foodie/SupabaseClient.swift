//
//  Supabase.swift
//  Foodie
//
//  Created by Michael Xcode on 2/17/24.
//

import Foundation
import Supabase

let supabase = SupabaseClient(
  supabaseURL: URL(string: "https://homdedmzasjiinzfchqn.supabase.co")!,
  supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhvbWRlZG16YXNqaWluemZjaHFuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDgxNjc1MDEsImV4cCI6MjAyMzc0MzUwMX0.2n67WioJl4rvqMidSlLKSThYsTA_lWgKxgzV-40sXck"
)
