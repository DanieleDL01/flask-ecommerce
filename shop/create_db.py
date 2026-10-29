from shop import app, db

# Crea un contesto dell'applicazione
with app.app_context():
    db.create_all()
    print("Database tables created!")