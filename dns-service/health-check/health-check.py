from flask import Flask, jsonify
import dns.resolver
import os
import sys


sys.stdout = sys.stderr
app = Flask(__name__)

@app.route("/health")
def health_check():
    try:
        resolver = dns.resolver.Resolver()
        resolver.nameservers = ['127.0.0.1']  # Local BIND DNS server
        answer = resolver.query(os.environ['DNS_HEALTH_CHECK_URL'], "A")
        if answer:
            status = {"status": "healthy", "result": str(answer.rrset)}
            return jsonify(status), 200
    except Exception as e:
        error_status = {"status": "unhealthy", "error": str(e)}
        print(f"Health Check Failed: {error_status}")
        return jsonify(error_status), 503

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
