use tokio::net::UdpSocket;
use std::net::SocketAddr;
use crate::user_manager::UserManager;

// Prepend a 2-byte identifier to the packet
pub fn prepend_identifier(packet: &[u8], identifier: u16) -> Vec<u8> {
    let mut result = Vec::new();
    result.extend_from_slice(&identifier.to_be_bytes()); // Convert identifier to bytes and add to result
    result.extend_from_slice(packet); // Add the original packet
    result
}

// Extract the 2-byte identifier from the packet
pub fn extract_identifier(packet: &[u8]) -> (u16, Vec<u8>) {
    let (id_bytes, packet) = packet.split_at(2);
    let identifier = u16::from_be_bytes([id_bytes[0], id_bytes[1]]); // Convert bytes back to u16
    (identifier, packet.to_vec())
}

// Process the packets
// pub async fn process_packet(
//     packet: &[u8], 
//     src: SocketAddr, 
//     socket: &UdpSocket, 
//     user_manager: &UserManager) -> Result<(), Box<dyn std::error::Error>> {
//     if let Some(mut user) = user_manager.get_user_by_ip_and_port(src.ip().to_string().as_str(), src.port()) {
//         let now = std::time::Instant::now();
//         if now.duration_since(user.last_packet_time) > std::time::Duration::from_secs(1) {
//             user.last_packet_time = now;
//         }

//         let modified_packet = prepend_identifier(packet, user.id);
//         let server_addr = format!("{}:{}", user.server_ip, user.server_port).parse::<SocketAddr>()?;
//         socket.send_to(&modified_packet, server_addr).await?;
//     } else {
//         let (identifier, modified_packet) = extract_identifier(packet);
//         if let Some(user) = user_manager.get_user_by_id(identifier) {
//             let user_addr = format!("{}:{}", user.ip, user.port).parse::<SocketAddr>()?;
//             socket.send_to(&modified_packet, user_addr).await?;
//         }
//     }

//     Ok(())
// }
