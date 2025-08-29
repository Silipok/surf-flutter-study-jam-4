use std::convert::Infallible;
use std::net::SocketAddr;
use hyper::service::{make_service_fn, service_fn};
use hyper::{Body, Method, Request, Response, Server, StatusCode};
use serde::{Deserialize, Serialize};
use rand::seq::SliceRandom;

/// Response structure matching the eightballapi.com format
#[derive(Serialize, Deserialize)]
struct MagicBallResponse {
    reading: String,
}

/// Magic 8-Ball predictions - classic responses
const PREDICTIONS: &[&str] = &[
    // Positive responses
    "It is certain",
    "It is decidedly so", 
    "Without a doubt",
    "Yes definitely",
    "You may rely on it",
    "As I see it, yes",
    "Most likely",
    "Outlook good",
    "Yes",
    "Signs point to yes",
    
    // Negative responses
    "Don't count on it",
    "My reply is no",
    "My sources say no",
    "Outlook not so good",
    "Very doubtful",
    
    // Neutral/Try again responses
    "Reply hazy, try again",
    "Ask again later",
    "Better not tell you now",
    "Cannot predict now",
    "Concentrate and ask again",
];

/// Get a random prediction
fn get_random_prediction() -> String {
    let mut rng = rand::thread_rng();
    PREDICTIONS.choose(&mut rng).unwrap().to_string()
}

/// Handle HTTP requests
async fn handle_request(req: Request<Body>) -> Result<Response<Body>, Infallible> {
    let mut response = Response::new(Body::empty());

    // Add CORS headers
    response.headers_mut().insert(
        "Access-Control-Allow-Origin",
        "*".parse().unwrap(),
    );
    response.headers_mut().insert(
        "Access-Control-Allow-Methods", 
        "GET, POST, OPTIONS".parse().unwrap(),
    );
    response.headers_mut().insert(
        "Access-Control-Allow-Headers",
        "Content-Type".parse().unwrap(),
    );
    response.headers_mut().insert(
        "Content-Type",
        "application/json".parse().unwrap(),
    );

    // Handle preflight OPTIONS request
    if req.method() == Method::OPTIONS {
        *response.status_mut() = StatusCode::OK;
        return Ok(response);
    }

    match (req.method(), req.uri().path()) {
        // Health check endpoint
        (&Method::GET, "/health") => {
            let health_response = serde_json::json!({
                "status": "ok",
                "service": "magic-ball-server"
            });
            *response.body_mut() = Body::from(health_response.to_string());
        }
        
        // API endpoint - matches eightballapi.com
        (&Method::GET, "/api") | (&Method::GET, "/") => {
            let prediction = get_random_prediction();
            let magic_response = MagicBallResponse {
                reading: prediction,
            };
            let json_response = serde_json::to_string(&magic_response).unwrap();
            *response.body_mut() = Body::from(json_response);
        }
        
        // 404 for other paths
        _ => {
            *response.status_mut() = StatusCode::NOT_FOUND;
            let error_response = serde_json::json!({
                "error": "Not found",
                "message": "Available endpoints: /api, /health"
            });
            *response.body_mut() = Body::from(error_response.to_string());
        }
    }

    Ok(response)
}

#[tokio::main]
async fn main() {
    let addr = SocketAddr::from(([127, 0, 0, 1], 3030));

    let make_svc = make_service_fn(|_conn| async {
        Ok::<_, Infallible>(service_fn(handle_request))
    });

    let server = Server::bind(&addr).serve(make_svc);

    println!("🔮 Magic 8-Ball Server starting...");
    println!("📍 Server running at: http://localhost:3030");
    println!("🌐 API endpoint: http://localhost:3030/api");
    println!("💚 Health check: http://localhost:3030/health");
    println!("\n🎯 Example predictions:");
    for (i, prediction) in PREDICTIONS.iter().take(5).enumerate() {
        println!("   {}. \"{}\"", i + 1, prediction);
    }
    println!("   ... and {} more!\n", PREDICTIONS.len() - 5);

    if let Err(e) = server.await {
        eprintln!("Server error: {}", e);
    }
}