#![cfg_attr(
    all(not(debug_assertions), target_os = "windows"),
    windows_subsystem = "windows"
)]

use tauri::Manager;
use std::sync::Arc;
use tokio::sync::Mutex;

mod commands;
mod database;
mod scraper;

use database::Database;
use scraper::PriceScraper;

#[derive(Default)]
struct AppState {
    db: Arc<Mutex<Option<Database>>>,
    scraper: Arc<Mutex<Option<PriceScraper>>>,
}

#[tokio::main]
async fn main() {
    tauri::Builder::default()
        .plugin(tauri_plugin_shell::init())
        .plugin(tauri_plugin_dialog::init())
        .plugin(tauri_plugin_fs::init())
        .manage(AppState::default())
        .setup(|app| {
            let app_handle = app.handle();
            
            // 初始化数据库
            tauri::async_runtime::spawn(async move {
                let state = app_handle.state::<AppState>();
                let mut db_lock = state.db.lock().await;
                
                match Database::new("component_prices.db").await {
                    Ok(db) => {
                        *db_lock = Some(db);
                        println!("数据库初始化成功");
                    }
                    Err(e) => {
                        eprintln!("数据库初始化失败: {}", e);
                    }
                }
                
                // 初始化爬虫
                let mut scraper_lock = state.scraper.lock().await;
                *scraper_lock = Some(PriceScraper::new());
                println!("爬虫初始化成功");
            });
            
            Ok(())
        })
        .invoke_handler(tauri::generate_handler![
            commands::search_component,
            commands::get_search_history,
            commands::add_to_favorites,
            commands::get_favorites,
            commands::export_data,
            commands::import_bom,
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}