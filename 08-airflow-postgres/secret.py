import json
import secrets

print(json.dumps({"key": secrets.token_hex(16)}))
