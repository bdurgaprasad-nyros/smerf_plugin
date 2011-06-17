# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_survey6_session',
  :secret      => '52364ac8f2c5836fdd77897163a27e0ac5bb166ba0d5e2005c788ef18636d94edfd4bea012fbe994ab4b27633d5fe1fb9bb00f1b0ab60f977cadb95bb2c75eea'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
