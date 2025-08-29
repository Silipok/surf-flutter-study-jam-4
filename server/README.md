# Magic 8-Ball Server 🔮

A simple Rust web server that provides Magic 8-Ball predictions via REST API.

## Features

- 🎯 **Compatible API**: Matches the eightballapi.com response format
- 🌐 **CORS Enabled**: Works with web applications
- ⚡ **Fast & Lightweight**: Built with Rust and Warp
- 🎲 **21 Classic Predictions**: Traditional Magic 8-Ball responses
- 💚 **Health Check**: Monitor server status

## API Endpoints

### Get Prediction
```
GET http://localhost:3030/api
GET http://localhost:3030/
```

**Response:**
```json
{
  "reading": "It is certain"
}
```

### Health Check
```
GET http://localhost:3030/health
```

**Response:**
```json
{
  "status": "ok",
  "service": "magic-ball-server"
}
```

## Running the Server

### Prerequisites
- Rust (install from [rustup.rs](https://rustup.rs/))

### Start Server
```bash
cd server
cargo run
```

The server will start on `http://localhost:3030`

### Development Mode (Auto-reload)
```bash
cargo install cargo-watch
cargo watch -x run
```

## Magic 8-Ball Predictions

The server includes 21 classic Magic 8-Ball responses:

**Positive (10):**
- It is certain
- It is decidedly so
- Without a doubt
- Yes definitely
- You may rely on it
- As I see it, yes
- Most likely
- Outlook good
- Yes
- Signs point to yes

**Negative (5):**
- Don't count on it
- My reply is no
- My sources say no
- Outlook not so good
- Very doubtful

**Neutral (6):**
- Reply hazy, try again
- Ask again later
- Better not tell you now
- Cannot predict now
- Concentrate and ask again

## Integration

Update your Flutter app's API endpoint to:
```dart
static const String _baseUrl = 'http://localhost:3030/api';
```

For production deployment, replace `localhost:3030` with your server's URL.

## Docker Support (Optional)

Create a `Dockerfile`:
```dockerfile
FROM rust:1.70 as builder
WORKDIR /app
COPY . .
RUN cargo build --release

FROM debian:bookworm-slim
COPY --from=builder /app/target/release/magic-ball-server /usr/local/bin/
EXPOSE 3030
CMD ["magic-ball-server"]
```

Build and run:
```bash
docker build -t magic-ball-server .
docker run -p 3030:3030 magic-ball-server
```
