from flask import Flask, jsonify
import dns.resolver
import os

app = Flask(__name__)

@app.route("/health")
def health_check():
    try:
        resolver = dns.resolver.Resolver()
        resolver.nameservers = ['127.0.0.1']  # Local BIND DNS server
        answer = resolver.query(os.environ['DNS_HEALTH_CHECK_URL'], "A")
        if answer:
            return jsonify({"status": "healthy", "result": str(answer.rrset)}), 200
    except Exception as e:
        return jsonify({"status": "unhealthy", "error": str(e)}), 503

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
