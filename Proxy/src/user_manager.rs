use dashmap::{DashMap, DashSet};
use futures_util::stream::SplitSink;
use rand::Rng;
use tokio::sync::mpsc::{Sender, UnboundedSender};
use std::sync::Arc;
use std::time::Instant;
use log::warn;
use tokio::net::TcpStream;
use tokio_tungstenite::tungstenite::Message;
use tokio_tungstenite::WebSocketStream;

#[derive(Clone)]
pub enum UserType {
    Client(u16, String),
    Server(String),
}

#[derive(Clone)]
pub struct User {
    pub user_type: UserType,
    pub sender: UnboundedSender<Message>,
    pub cancel_token: UnboundedSender<()>,
}

#[derive(Clone)]
pub struct UserManager {
    users: Arc<DashMap<u16, User>>,
    servers: Arc<DashMap<String, User>>,
}

impl UserManager {
    pub fn new() -> Self {
        UserManager {
            users: Arc::new(DashMap::new()),
            servers: Arc::new(DashMap::new()),
        }
    }

    // Method to get user by identifier
    pub fn get_user_by_id(&self, id: u16) -> Option<User> {
        self.users.get(&id).map(|x| x.clone())
    }

    // Method to get user by identifier
    pub fn get_server_by_id(
        &self,
        id: &str,
    ) -> Option<User> {
        self.servers.get(id).map(|x| x.clone())
    }

    pub fn convert_token(&self, token: &str) -> u16 {
        token.bytes()
            .fold(0u16, |acc, byte| acc.wrapping_mul(31).wrapping_add(byte as u16))
    }

    // Method to add or update user
    pub fn add_user(
        &self,
        sender: UnboundedSender<Message>,
        cancel_token: UnboundedSender<()>,
        server_id: &str,
        token: String,
    ) -> u16 {
        let user_id = self.convert_token(&token);
        let user = User {
            user_type: UserType::Client(user_id, server_id.to_string()),
            sender,
            cancel_token,
        };

        if self.users.contains_key(&user_id) {
            warn!("User with ID {} already exists, overwriting", user_id);
            self.users.remove(&user_id);
        }

        self.users.insert(user_id, user);
        user_id
    }

    pub fn remove_user(&self, id: u16) {
        self.users.remove(&id);
    }

    pub fn add_server(
        &self,
        sender: UnboundedSender<Message>,
        cancel_token: UnboundedSender<()>,
        server_id: &str,
    ) {
        let user = User {
            user_type: UserType::Server(server_id.to_string()),
            sender,
            cancel_token,
        };

        self.servers.insert(server_id.to_owned(), user);
    }

    pub fn remove_server(&self, id: &str) {
        self.servers.remove(id);
    }
}