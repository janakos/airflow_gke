# Credit - https://github.com/apache/airflow/discussions/21358#discussioncomment-2119846
import logging
import os

# Custom Security Manager in order to get around the `role_keys` missing from Google OAuth response
# See: https://github.com/apache/airflow/issues/16783
from airflow.www.security import AirflowSecurityManager
from flask_appbuilder.security.manager import AUTH_OAUTH

basedir = os.path.abspath(os.path.dirname(__file__))
logger = logging.getLogger(__name__)

GOOGLE_CLIENT_ID = os.getenv("GOOGLE_OAUTH2_CLIENT_ID")
GOOGLE_SECRET = os.getenv("GOOGLE_OAUTH2_SECRET")

AUTH_TYPE = AUTH_OAUTH
AUTH_ROLE_ADMIN = "Admin"
AUTH_USER_REGISTRATION = True
AUTH_USER_REGISTRATION_ROLE = "User"  # Testing with just everyone as admin

OAUTH_PROVIDERS = [
    {
        "name": "google",
        "icon": "fa-google",
        "token_key": "access_token",
        "remote_app": {
            "client_id": GOOGLE_CLIENT_ID,
            "client_secret": GOOGLE_SECRET,
            "api_base_url": "https://www.googleapis.com/oauth2/v2/",
            "client_kwargs": {"scope": "email profile"},
            "request_token_url": None,
            "access_token_url": "https://accounts.google.com/o/oauth2/token",
            "authorize_url": "https://accounts.google.com/o/oauth2/auth",
            "jwks_uri": "https://www.googleapis.com/oauth2/v3/certs",
        },
    }
]


AUTH_ROLES_MAPPING = {"devs": ["User"], "admins": ["Admin"]}


class GoogleAirflowSecurityManager(AirflowSecurityManager):
    def oauth_user_info(self, provider, resp):
        assert (
            provider == "google"
        ), "Google provider is only supported in this Security Manager"
        me = self.appbuilder.sm.oauth_remotes[provider].get("userinfo")
        data = me.json()
        email = data.get("email", "")
        logger.error(data)
        # Maps back to AUTH_ROLES_MAPPING keys
        role_keys = ["devs"]
        return {
            "username": "google_" + data.get("id", ""),
            "first_name": data.get("given_name", ""),
            "last_name": data.get("family_name", ""),
            "email": email,
            "role_keys": role_keys,
        }


SECURITY_MANAGER_CLASS = GoogleAirflowSecurityManager
