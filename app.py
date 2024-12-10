import secrets
from flask import *
from flask_mysqldb import MySQL
import  hashlib
from credentials  import*


app = Flask(__name__)
app.config['SECRET_KEY']=my_token
app.config['MYSQL_HOST'] = my_host
app.config['MYSQL_USER'] = my_user
app.config['MYSQL_PASSWORD'] = my_password
app.config['MYSQL_DB'] =  my_db
app.config['MYSQL_CURSORCLASS'] =my_CURSORCLASS
from flask_mail import Mail, Message
from datetime import datetime, timedelta



app.config['MAIL_SERVER'] = 'mail.alabdigital.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_DEFAULT_SENDER'] = 'support_alabdigital@alabdigital.com'
app.config['MAIL_USERNAME'] = 'support_alabdigital@alabdigital.com'
app.config['MAIL_PASSWORD'] = 't$sZm$Z7m~rt.tO2_s@TGVd_alabdigital@alabdig'
mail = Mail(app)
mysql = MySQL()
mysql.init_app(app)



###################### Dossier
def getLogin(email, table):
    cur = mysql.connection.cursor()
    if email not in session:
        loggedIn = False
        firstName = ''
    else:
        loggedIn = True
        cur.execute("SELECT ident, name FROM " + table + " WHERE " + email + " = '" + session[email] + "'")
        useradminID, firstName = cur.fetchone()

    cur.close()
    return loggedIn, firstName

# Fonction is_valid
def is_valid(email, email_t, password, table):
    cur = mysql.connection.cursor()
    cur.execute('SELECT {}, password FROM {}'.format(email_t, table))
    data = cur.fetchall()
    for row in data:
        if row[0] == str(email) and row[1] == hashlib.md5(password.encode()).hexdigest():
            return True
    return False

@app.route('/logout')
def logout():
    session.clear()

    return redirect(url_for('login'))






@app.route("/inscription_admin",methods=['POST', 'GET'])
def inscription_admin():
    if request.method == 'POST':
        name = request.form['name']
        prenom = request.form['prenom']
        email = request.form['email']
        numero_telephone = request.form['numero_telephone']
        password = request.form['password']
        confirm_password = request.form['confirm_password']

        # Vérification de la confirmation de mot de passe
        if password != confirm_password:
            return "Les mots de passe ne correspondent pas. Veuillez réessayer."

        hashed_password = hashlib.md5(password.encode()).hexdigest()
        cursor = mysql.connection.cursor()
        
        cursor.execute("SELECT * FROM admin WHERE email_admin = %s", (email,))
        existing_user = cursor.fetchone()

        if existing_user:
            flash("Cet email est déjà utilisé. Veuillez en utiliser un autre.", "danger")
            return redirect('/inscription_admin')

        try:
            cursor = mysql.connection.cursor()
            query = """INSERT INTO `admin` (name, prenom, email_admin, numero_telephone, password) 
                       VALUES (%s, %s, %s, %s, %s)"""
            cursor.execute(query, (name, prenom, email, numero_telephone, hashed_password))
            mysql.connection.commit()
            return redirect('/')
        except Exception as e:
            return f"Erreur lors de l'inscription : {e}"
    return render_template('admin/connexion/cree_compte.html')

@app.route("/admin_tableau_de_bord")
def admin_tableau_de_bord():
    if 'email_admin' not in session:
        return redirect(url_for('login'))

    # Récupérer les informations du chef de brigade connecté
    loggedIn, firstName = getLogin('email_admin', 'admin')
    if not loggedIn:
        return redirect(url_for('login'))
    return render_template('admin/index.html', firstName=firstName)

@app.route("/ajout_dossier")
def ajout_dossier():
    if 'email_admin' not in session:
        return redirect(url_for('login'))

    # Récupérer les informations du chef de brigade connecté
    loggedIn, firstName = getLogin('email_admin', 'admin')
    if not loggedIn:
        return redirect(url_for('login'))
    return render_template('admin/dossier/ajout_dossier.html',firstName=firstName)

@app.route('/ajouter_dossier', methods=['GET', 'POST'])
def ajouter_dossier():
    if 'email_admin' not in session:
        return redirect(url_for('login'))

    # Récupérer les informations du chef de brigade connecté
    loggedIn, firstName = getLogin('email_admin', 'admin')
    if not loggedIn:
        return redirect(url_for('login'))
    if request.method == 'POST':
        # Récupérer les informations du formulaire
        nom = request.form['nom']
        statut = 'attente'  # Le statut est toujours 'attente' par défaut
        raison = request.form['raison']

        # Insérer le dossier dans la base de données
        cur = mysql.connection.cursor()
        cur.execute("""
            INSERT INTO dossier (nom, statut, raison_rejet)
            VALUES (%s, %s, %s)
        """, (nom, statut, raison))
        mysql.connection.commit()
        cur.close()

        return redirect(url_for('liste_dossier'))  

@app.route("/liste_dossier")
def liste_dossier():
    if 'email_admin' not in session:
        return redirect(url_for('login'))

    # Récupérer les informations du chef de brigade connecté
    loggedIn, firstName = getLogin('email_admin', 'admin')
    if not loggedIn:
        return redirect(url_for('login'))
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM dossier")  # Vous pouvez ajuster cette requête si vous avez des filtres
    dossiers = cur.fetchall()  # Récupérer tous les résultats sous forme de liste
    cur.close()

    return render_template('admin/dossier/liste_dossier.html',dossiers=dossiers,firstName=firstName)

@app.route('/valider_dossier_a/<int:dossier_id>', methods=['POST'])
def valider_dossier_a(dossier_id):
    cur = mysql.connection.cursor()

    # Récupérer les données du dossier
    cur.execute("SELECT nom, date_creation FROM dossier WHERE id = %s", (dossier_id,))
    dossier = cur.fetchone()
    
    if dossier:
        # Insérer les données dans gestion_chef_brigade
        cur.execute("""
            INSERT INTO gestion_chef_brigade (nom_dossier, date_creation, statut, raison)
            VALUES (%s, %s, %s, %s)
        """, (dossier[0], dossier[1], 'En attente', None))
        
        # Supprimer le dossier de la table dossier
        cur.execute("DELETE FROM dossier WHERE id = %s", (dossier_id,))
        
        # Commit les modifications
        mysql.connection.commit()

    cur.close()
    return redirect(url_for('liste_dossier'))




############ chef brigade
@app.route("/inscription_chefbrigade",methods=['POST', 'GET'])
def inscription_chefbrigade():
    if request.method == 'POST':
        name = request.form['name']
        prenom = request.form['prenom']
        email = request.form['email']
        numero_telephone = request.form['numero_telephone']
        password = request.form['password']
        confirm_password = request.form['confirm_password']

        # Vérification de la confirmation de mot de passe
        if password != confirm_password:
            return "Les mots de passe ne correspondent pas. Veuillez réessayer."

        hashed_password = hashlib.md5(password.encode()).hexdigest()
        cursor = mysql.connection.cursor()
        
        cursor.execute("SELECT * FROM chef_brigade WHERE email_chefbrigade = %s", (email,))
        existing_user = cursor.fetchone()

        if existing_user:
            flash("Cet email est déjà utilisé. Veuillez en utiliser un autre.", "danger")
            return redirect('/inscription_admin')

        try:
            cursor = mysql.connection.cursor()
            query = """INSERT INTO `chef_brigade` (name, prenom, email_chefbrigade, numero_telephone, password) 
                       VALUES (%s, %s, %s, %s, %s)"""
            cursor.execute(query, (name, prenom, email, numero_telephone, hashed_password))
            mysql.connection.commit()
            return redirect('/')
        except Exception as e:
            return f"Erreur lors de l'inscription : {e}"
    return render_template('chef_brigade/connexion/cree_compte.html')

@app.route("/chef_brigade_tableau_de_bord")
def chef_brigade_tableau_de_bord():
    loggedIn, firstName = getLogin('email_chefbrigade', 'chef_brigade')
    if not loggedIn:
        return redirect(url_for('login'))

    # Identifier l'utilisateur connecté
    cur = mysql.connection.cursor()
    cur.execute("SELECT ident FROM chef_brigade WHERE email_chefbrigade = %s", [session['email_chefbrigade']])
    user = cur.fetchone()
    
    chef_brigade_id = user[0]

    # Requêtes séparées pour chaque statut
    cur.execute("SELECT COUNT(*) FROM gestion_chef_brigade WHERE statut = 'En attente'")
    en_attente = cur.fetchone()[0]

    cur.execute("SELECT COUNT(*) FROM gestion_chef_brigade WHERE chef_brigade_id = %s AND statut = 'En cours'", [chef_brigade_id])
    en_cours = cur.fetchone()[0]

    cur.execute("SELECT COUNT(*) FROM gestion_chef_brigade WHERE chef_brigade_id = %s AND statut = 'Terminé'", [chef_brigade_id])
    termine = cur.fetchone()[0]
    cur.close()
    return render_template('chef_brigade/index.html', firstName=firstName, en_attente=en_attente, en_cours=en_cours, termine=termine)

@app.route('/liste_gestion_chef_brigade')
def liste_gestion_chef_brigade():
    loggedIn, firstName = getLogin('email_chefbrigade', 'chef_brigade')
    if not loggedIn:
        return redirect(url_for('login'))
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM gestion_chef_brigade")
    dossiers = cur.fetchall()
    cur.close()
    
    return render_template('chef_brigade/dossier/liste_chef_brigade.html', dossiers=dossiers,loggedIn=loggedIn, firstName=firstName)

@app.route("/dossiers_disponibles")
def liste_dossiers_chef_brigade():
    loggedIn, firstName = getLogin('email_chefbrigade', 'chef_brigade')
    if not loggedIn:
        return redirect(url_for('login'))  # Si non connecté, rediriger vers la page de login

    cur = mysql.connection.cursor()

    # Modifier la requête SQL pour récupérer les dossiers où chef_assigned est NULL (c'est-à-dire non assignés)
    cur.execute("SELECT id, nom_dossier, date_creation, statut FROM gestion_chef_brigade WHERE chef_brigade_id IS NULL")
    dossiers = cur.fetchall()
    cur.close()

    # Passer les informations à la vue
    return render_template(
        'chef_brigade/dossier/liste_chef_brigade.html',
        dossiers=dossiers,  # Liste des dossiers non assignés
        loggedIn=loggedIn,
        firstName=firstName
    )

@app.route("/assigner_dossier/<int:id_dossier>", methods=['POST'])
def assigner_dossier(id_dossier):
    # Vérifier l'authentification du chef de brigade
    if 'email_chefbrigade' not in session:
        return redirect(url_for('login'))

    # Récupérer les informations du chef de brigade connecté
    loggedIn, firstName = getLogin('email_chefbrigade', 'chef_brigade')
    if not loggedIn:
        return redirect(url_for('login'))

    cur = mysql.connection.cursor()

    # Obtenir l'identifiant du chef connecté
    cur.execute("SELECT ident FROM chef_brigade WHERE email_chefbrigade = %s", [session['email_chefbrigade']])
    chef_brigade = cur.fetchone()
    if not chef_brigade:
        return render_template('error.html', message="Chef de brigade introuvable.")

    chef_brigade_id = chef_brigade[0]

    # Vérifier l'existence du dossier
    cur.execute("SELECT id, statut, chef_brigade_id FROM gestion_chef_brigade WHERE id = %s", [id_dossier])
    dossier = cur.fetchone()
    if not dossier:
        return render_template('error.html', message="Dossier introuvable.")

    _, statut, chef_brigade_existing = dossier

    # Vérifier si le dossier est déjà assigné ou traité
    if chef_brigade_existing is not None or statut != 'En attente':
        return render_template('error.html', message="Ce dossier est déjà assigné ou traité.")

    try:
        # Assigner le dossier et mettre à jour son statut
        cur.execute("""
            UPDATE gestion_chef_brigade
            SET statut = 'En cours', chef_brigade_id = %s, date_envoi = NOW()
            WHERE id = %s
        """, [chef_brigade_id, id_dossier])
        
        

        mysql.connection.commit()

        return redirect(url_for('liste_dossiers_assignes'))
    except Exception as e:
        mysql.connection.rollback()
        return render_template('error.html', message=f"Erreur lors de l'assignation : {e}")
    finally:
        cur.close()

@app.route('/terminer_dossier_chefbrigade/<int:id_dossier>', methods=['POST'])
def terminer_dossier_chefbrigade(id_dossier):
    # Vérification de la session
    if 'email_chefbrigade' not in session:
        return redirect(url_for('login'))

    # Récupérer les informations du chef de brigade connecté
    loggedIn, firstName = getLogin('email_chefbrigade', 'chef_brigade')
    if not loggedIn:
        return redirect(url_for('login'))

    cur = mysql.connection.cursor()

    # Vérifier si le dossier existe et est assigné au chef de brigade
    cur.execute("""
        SELECT id, nom_dossier, statut, chef_brigade_id
        FROM gestion_chef_brigade
        WHERE id = %s AND chef_brigade_id = (
            SELECT ident FROM chef_brigade WHERE email_chefbrigade = %s
        )
    """, (id_dossier, session['email_chefbrigade']))
    dossier = cur.fetchone()

    if dossier:
        dossier_id, nom_dossier, statut, chef_brigade_id = dossier

        # Vérifier que le statut est 'En cours'
        if statut == 'En cours':
            # Récupérer le nom complet du chef de brigade
            cur.execute("""
                SELECT CONCAT(name, ' ', prenom) AS full_name
                FROM chef_brigade
                WHERE email_chefbrigade = %s
            """, [session['email_chefbrigade']])
            validateur = cur.fetchone()[0]

            # Insérer dans gestion_brigade
            cur.execute("""
                INSERT INTO gestion_brigade (nom_dossier, date_creation, statut, chef_brigade_id, validateur)
                VALUES (%s, NOW(), 'En attente', %s, %s)
            """, (nom_dossier, chef_brigade_id, validateur))

            # Supprimer le dossier de gestion_chef_brigade
            cur.execute("UPDATE gestion_chef_brigade SET statut = 'Terminé' WHERE id = %s", [id_dossier])

            # Commit
            mysql.connection.commit()
            cur.close()
            return redirect(url_for('liste_dossiers_assignes'))  # Redirection vers la liste des dossiers assignés

    cur.close()
    return render_template('error.html', message="Dossier introuvable ou non assigné.")

@app.route("/dossiers_assignes")
def liste_dossiers_assignes():
    # Vérifier si un chef de brigade est connecté
    if 'email_chefbrigade' not in session:
        return redirect(url_for('login'))

    # Récupérer les informations du chef de brigade connecté
    loggedIn, firstName = getLogin('email_chefbrigade', 'chef_brigade')
    if not loggedIn:
        return redirect(url_for('login'))

    cur = mysql.connection.cursor()

    # Identifier le chef de brigade connecté
    cur.execute("SELECT ident FROM chef_brigade WHERE email_chefbrigade = %s", [session['email_chefbrigade']])
    chef_brigade = cur.fetchone()

    if not chef_brigade:
        return render_template('error.html', message="Chef de brigade introuvable.")

    chef_brigade_id = chef_brigade[0]

    # Récupérer les dossiers assignés à ce chef
    cur.execute("""
        SELECT id, nom_dossier, date_creation, statut
        FROM gestion_chef_brigade
        WHERE chef_brigade_id = %s AND statut = 'En cours'
    """, [chef_brigade_id])

    dossiers = cur.fetchall()
    cur.close()

    return render_template(
        'chef_brigade/dossier/dossiers_assignes.html',
        dossiers=dossiers,
        loggedIn=loggedIn,
        firstName=firstName
    )

@app.route("/valider_dossier/<int:id_dossier>", methods=['POST'])
def valider_dossier(id_dossier):
    if 'email_chefbrigade' not in session:
        return redirect(url_for('login'))  # Redirige vers la page de login si non connecté

    # Récupérer le nom du chef de brigade connecté
    loggedIn, firstName = getLogin('email_chefbrigade', 'chef_brigade')
    if not loggedIn:
        return redirect(url_for('login'))

    cur = mysql.connection.cursor()

    # Récupérer les informations du dossier
    cur.execute("SELECT nom_dossier, statut FROM gestion_chef_brigade WHERE id = %s", [id_dossier])
    dossier = cur.fetchone()

    if dossier:
        nom_dossier = dossier[0]
        statut = dossier[1]

        # Si le dossier est assigné, le valider et le déplacer vers gestion_brigade
        if statut == 'Assigné':
            cur.execute("""
                INSERT INTO gestion_brigade (nom_dossier, date_creation, statut, chef_validateur)
                VALUES (%s, NOW(), 'Validé', %s)
            """, [nom_dossier, firstName])

            # Mettre à jour le statut du dossier dans gestion_chef_brigade
            cur.execute("UPDATE gestion_chef_brigade SET statut = 'Validé' WHERE id = %s", [id_dossier])

            mysql.connection.commit()
            cur.close()
            return redirect(url_for('dossiers_valides'))  # Redirige vers la page des dossiers validés

    cur.close()
    return render_template('error.html', message="Dossier introuvable.")


@app.route('/dossiers_valides')
def dossiers_valides():
    # Vérifier si un chef de brigade est connecté
    if 'email_chefbrigade' not in session:
        return redirect(url_for('login'))

    # Récupérer les informations du chef de brigade connecté
    loggedIn, firstName = getLogin('email_chefbrigade', 'chef_brigade')
    if not loggedIn:
        return redirect(url_for('login'))

    cur = mysql.connection.cursor()

    # Identifier le chef de brigade connecté
    cur.execute("SELECT ident FROM chef_brigade WHERE email_chefbrigade = %s", [session['email_chefbrigade']])
    chef_brigade = cur.fetchone()

    if not chef_brigade:
        return render_template('error.html', message="Chef de brigade introuvable.")

    chef_brigade_id = chef_brigade[0]

    # Récupérer les dossiers assignés à ce chef
    cur.execute("""
        SELECT *
        FROM gestion_chef_brigade
        WHERE chef_brigade_id = %s AND statut = 'Terminé'
    """, [chef_brigade_id])

    dossiers = cur.fetchall()
    cur.close()
    return render_template('chef_brigade/dossier/dossiers_valides.html', dossiers=dossiers, firstName=firstName, loggedIn=loggedIn,)









############ brigade
@app.route("/inscription_brigade",methods=['POST', 'GET'])
def inscription_brigade():
    if request.method == 'POST':
        name = request.form['name']
        prenom = request.form['prenom']
        email = request.form['email']
        numero_telephone = request.form['numero_telephone']
        password = request.form['password']
        confirm_password = request.form['confirm_password']

        # Vérification de la confirmation de mot de passe
        if password != confirm_password:
            return "Les mots de passe ne correspondent pas. Veuillez réessayer."

        hashed_password = hashlib.md5(password.encode()).hexdigest()
        cursor = mysql.connection.cursor()
        
        cursor.execute("SELECT * FROM brigade WHERE email_brigade = %s", (email,))
        existing_user = cursor.fetchone()

        if existing_user:
            flash("Cet email est déjà utilisé. Veuillez en utiliser un autre.", "danger")
            return redirect('/inscription_admin')

        try:
            cursor = mysql.connection.cursor()
            query = """INSERT INTO `brigade` (name, prenom, email_brigade, numero_telephone, password) 
                       VALUES (%s, %s, %s, %s, %s)"""
            cursor.execute(query, (name, prenom, email, numero_telephone, hashed_password))
            mysql.connection.commit()
            return redirect('/')
        except Exception as e:
            return f"Erreur lors de l'inscription : {e}"
    return render_template('brigade/connexion/cree_compte.html')

@app.route("/dossiers_en_attente_brigade")
def dossiers_en_attente_brigade():
    # Vérifier si l'utilisateur est connecté et est un membre de la brigade
    loggedIn, firstName = getLogin('email_brigade', 'brigade')
    if not loggedIn:
        return redirect(url_for('login'))

    # Récupérer les dossiers en attente
    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT *
        FROM gestion_brigade
        WHERE statut = 'En attente'
    """)
    dossiers = cur.fetchall()
    cur.close()

    return render_template(
        'brigade/dossier/dossiers_en_attente.html',
        dossiers=dossiers,
        loggedIn=loggedIn,
        firstName=firstName
    )

@app.route("/assigner_dossier_brigade/<int:id_dossier>", methods=['POST'])
def assigner_dossier_brigade(id_dossier):
    # Vérification si l'utilisateur est connecté
    if 'email_brigade' not in session:
        return redirect(url_for('login'))

    # Récupérer l'ID du membre de la brigade à partir de la session
    cur = mysql.connection.cursor()
    cur.execute("SELECT ident FROM brigade WHERE email_brigade = %s", [session['email_brigade']])
    brigade = cur.fetchone()
    brigade_id = brigade[0] if brigade else None

    if not brigade_id:
        return "Erreur : utilisateur non trouvé", 400

    # Assigner le dossier et mettre à jour le statut en 'En cours'
    cur.execute("""
        UPDATE gestion_brigade
        SET statut = 'En cours', brigade_id = %s
        WHERE id = %s
    """, (brigade_id, id_dossier))
    mysql.connection.commit()
    cur.close()

    flash("Dossier assigné avec succès.", "success")
    return redirect(url_for('dossiers_en_attente_brigade'))

@app.route("/terminer_dossier_brigade/<int:id_dossier>", methods=['POST'])
def terminer_dossier_brigade(id_dossier):
    # Vérifier si l'utilisateur est connecté
    if 'email_brigade' not in session:
        return redirect(url_for('login'))

    # Récupérer les informations du brigade connecté
    cur = mysql.connection.cursor()
    cur.execute("SELECT ident, CONCAT(name, ' ', prenom) AS nom_brigade FROM brigade WHERE email_brigade = %s", 
                [session['email_brigade']])
    brigade = cur.fetchone()
    brigade_id = brigade[0]
    nom_brigade = brigade[1]

    if not brigade_id:
        return "Erreur : membre de brigade introuvable", 400

    # Récupérer les informations du dossier depuis gestion_brigade
    cur.execute("""
        SELECT nom_dossier, date_creation
        FROM gestion_brigade
        WHERE id = %s AND brigade_id = %s
    """, (id_dossier, brigade_id))
    dossier = cur.fetchone()

    if not dossier:
        return "Erreur : dossier introuvable ou non assigné", 400

    # Transférer les informations dans la table gestion_securisation
    cur.execute("""
        INSERT INTO gestion_securisation (nom_dossier, date_creation, date_validation, nom_brigade, statut)
        VALUES (%s, %s, NOW(), %s, 'En attente')
    """, (dossier[0], dossier[1], nom_brigade))

    # Mettre à jour le statut du dossier dans gestion_brigade en "Terminé"
    cur.execute("""
        UPDATE gestion_brigade
        SET statut = 'Terminé'
        WHERE id = %s
    """, (id_dossier,))
    mysql.connection.commit()
    cur.close()

    flash("Le dossier a été validé et transféré avec succès.", "success")
    return redirect(url_for('dossiers_brigade_en_cours'))

@app.route("/dossiers_brigade_en_cours")
def dossiers_brigade_en_cours():
    # Vérifier si l'utilisateur est connecté
    if 'email_brigade' not in session:
        return redirect(url_for('login'))

    # Récupérer les informations de la brigade connectée
    loggedIn, firstName = getLogin('email_brigade', 'brigade')
    if not loggedIn:
        return redirect(url_for('login'))

    cur = mysql.connection.cursor()
    # Récupérer les dossiers avec le statut "En cours" pour la brigade connectée
    cur.execute("""
        SELECT gb.id, gb.nom_dossier, gb.date_creation, gb.statut
        FROM gestion_brigade gb
        JOIN brigade b ON gb.brigade_id = b.ident
        WHERE gb.statut = 'En cours' AND b.email_brigade = %s
    """, [session['email_brigade']])
    dossiers = cur.fetchall()
    cur.close()

    return render_template(
        "brigade/dossier/dossiers_en_cours.html",
        dossiers=dossiers,
        loggedIn=loggedIn,
        firstName=firstName
    )

@app.route("/dossiers_brigade_valide")
def dossiers_brigade_valide():
    # Vérifier si l'utilisateur est connecté
    if 'email_brigade' not in session:
        return redirect(url_for('login'))

    # Récupérer les informations de la brigade connectée
    loggedIn, firstName = getLogin('email_brigade', 'brigade')
    if not loggedIn:
        return redirect(url_for('login'))
    
    cur = mysql.connection.cursor()
    
    # Identifier le chef de brigade connecté
    cur.execute("SELECT ident FROM brigade WHERE email_brigade = %s", [session['email_brigade']])
    brigade = cur.fetchone()
    if not brigade:
        flash("Erreur : brigade introuvable.")
        return redirect(url_for('login'))
    
    brigade_id = brigade[0]
    
    # Récupérer les dossiers avec le statut "Terminé" pour la brigade connectée
    cur.execute("""SELECT * FROM gestion_brigade WHERE brigade_id = %s AND statut = 'Terminé'""", [brigade_id])
    dossiers = cur.fetchall()
    cur.close()
    
    return render_template(
        "brigade/dossier/dossiers_valides.html",
        dossiers=dossiers,
        loggedIn=loggedIn,
        firstName=firstName
    )

@app.route("/brigade_tableau_de_bord")
def brigade_tableau_de_bord():
    if 'email_brigade' not in session:
        return redirect(url_for('login'))

    # Récupérer les informations de la brigade connectée
    loggedIn, firstName = getLogin('email_brigade', 'brigade')
    if not loggedIn:
        return redirect(url_for('login'))
    
    
    cur = mysql.connection.cursor()
    cur.execute("SELECT ident FROM brigade WHERE email_brigade = %s", [session['email_brigade']])
    brigade = cur.fetchone()
    if not brigade:
        flash("Brigade introuvable.")
        return redirect(url_for('login'))
    
    brigade_id = brigade[0]

    # Requêtes séparées pour chaque statut
    cur.execute("SELECT COUNT(*) FROM gestion_brigade WHERE  statut = 'En attente'")
    en_attente = cur.fetchone()[0]

    cur.execute("SELECT COUNT(*) FROM gestion_brigade WHERE brigade_id = %s AND statut = 'En cours'", [brigade_id])
    en_cours = cur.fetchone()[0]

    cur.execute("SELECT COUNT(*) FROM gestion_brigade WHERE brigade_id = %s AND statut = 'Terminé'", [brigade_id])
    termine = cur.fetchone()[0]
    cur.close()
    return render_template('brigade/index.html',loggedIn=loggedIn,firstName=firstName,en_attente=en_attente,en_cours=en_cours,termine=termine)






###################securisation
@app.route("/inscription_securisation",methods=['POST', 'GET'])
def inscription_securisation():
    if request.method == 'POST':
        name = request.form['name']
        prenom = request.form['prenom']
        email = request.form['email']
        numero_telephone = request.form['numero_telephone']
        password = request.form['password']
        confirm_password = request.form['confirm_password']

        # Vérification de la confirmation de mot de passe
        if password != confirm_password:
            return "Les mots de passe ne correspondent pas. Veuillez réessayer."

        hashed_password = hashlib.md5(password.encode()).hexdigest()
        cursor = mysql.connection.cursor()
        
        cursor.execute("SELECT * FROM securisation WHERE email_securisation = %s", (email,))
        existing_user = cursor.fetchone()

        if existing_user:
            flash("Cet email est déjà utilisé. Veuillez en utiliser un autre.", "danger")
            return redirect('/inscription_admin')

        try:
            cursor = mysql.connection.cursor()
            query = """INSERT INTO `securisation` (name, prenom, email_securisation, numero_telephone, password) 
                       VALUES (%s, %s, %s, %s, %s)"""
            cursor.execute(query, (name, prenom, email, numero_telephone, hashed_password))
            mysql.connection.commit()
            return redirect('/')
        except Exception as e:
            return f"Erreur lors de l'inscription : {e}"
    return render_template('securisation/connexion/cree_compte.html')

@app.route("/liste_gestion_securisation")
def liste_gestion_securisation():
    # Vérifier si l'utilisateur est connecté comme un membre de la sécurisation
    if 'email_securisation' not in session:
        return redirect(url_for('login'))

    # Récupérer l'état de connexion et le prénom
    loggedIn, firstName = getLogin('email_securisation', 'securisation')
    if not loggedIn:
        return redirect(url_for('login'))

    # Récupérer la liste de tous les dossiers dans gestion_securisation
    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT *
        FROM gestion_securisation
        WHERE statut = 'En attente'
    """)
    dossiers = cur.fetchall()
    cur.close()

    return render_template(
        "securisation/dossier/liste_gestion_securisation.html",
        dossiers=dossiers,
        loggedIn=loggedIn,
        firstName=firstName
    )

@app.route("/liste_dossiers_assignes_securisation")
def liste_dossiers_assignes_securisation():
    # Vérifier si l'utilisateur est connecté et est un membre de la sécurisation
    if 'email_securisation' not in session:
        return redirect(url_for('login'))

    # Récupérer l'email de l'utilisateur connecté et vérifier son statut
    loggedIn, firstName = getLogin('email_securisation', 'securisation')
    if not loggedIn:
        return redirect(url_for('login'))

    # Récupérer les dossiers en cours pour cet utilisateur
    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT gs.id, gs.nom_dossier, gs.date_creation, gs.statut
        FROM gestion_securisation gs
        JOIN securisation s ON gs.securisation_id = s.ident
        WHERE gs.statut = 'En cours' AND s.email_securisation = %s
    """, [session['email_securisation']])
    dossiers = cur.fetchall()
    cur.close()
    return render_template( 
        "securisation/dossier/liste_dossiers_assignes.html",
        dossiers=dossiers,
        loggedIn=loggedIn,
        firstName=firstName
    )

@app.route("/assigner_dossier_securisation/<int:dossier_id>", methods=["POST"])
def assigner_dossier_securisation(dossier_id):
    # Vérifier si l'utilisateur est connecté comme un membre de la sécurisation
    if 'email_securisation' not in session:
        return redirect(url_for('login'))

    # Récupérer l'état de connexion et le prénom
    loggedIn, firstName = getLogin('email_securisation', 'securisation')
    if not loggedIn:
        return redirect(url_for('login'))

    # Récupérer l'ID de la personne qui assigne
    cur = mysql.connection.cursor()
    cur.execute("SELECT ident FROM securisation WHERE email_securisation = %s", [session['email_securisation']])
    securisation_id = cur.fetchone()[0]

    # Assigner le dossier à la personne connectée et mettre à jour le statut
    cur.execute("""
        UPDATE gestion_securisation
        SET securisation_id = %s, statut = 'En cours'
        WHERE id = %s
    """, (securisation_id, dossier_id))
    mysql.connection.commit()
    cur.close()

    flash("Dossier assigné avec succès.", "success")
    return redirect(url_for('liste_dossiers_assignes_securisation'))

@app.route('/valider_dossier_securisation/<int:id_dossier>', methods=['POST'])
def valider_dossier_securisation(id_dossier):
    # Vérifier si l'utilisateur est connecté et est un membre de la sécurisation
    if 'email_securisation' not in session:
        return redirect(url_for('login'))

    # Récupérer l'email et le nom de l'utilisateur connecté
    loggedIn, firstName = getLogin('email_securisation', 'securisation')
    if not loggedIn:
        return redirect(url_for('login'))
    
    cur = mysql.connection.cursor()
    cur.execute("SELECT ident, CONCAT(name, ' ', prenom) AS nom_securisation FROM securisation WHERE email_securisation = %s", 
                [session['email_securisation']])
    securisation = cur.fetchone()
    securisation_id = securisation[0]
    nom_securisation = securisation[1]

    # Récupérer le dossier de la table gestion_securisation
    cur = mysql.connection.cursor()
    
    
    cur.execute("""
        SELECT *
        FROM gestion_securisation
        WHERE id = %s AND securisation_id = %s
    """, (id_dossier, securisation_id))
    dossier = cur.fetchone()

    if dossier:
        # Mise à jour du statut dans gestion_securisation pour marquer le dossier comme terminé
        cur.execute("""
            UPDATE gestion_securisation
            SET statut = 'Terminé'
            WHERE id = %s
        """, [id_dossier])

        # Insertion du dossier dans gestion_evaluation_cadastrale avec le nom du validateur
       
        
        cur.execute("""
        INSERT INTO gestion_evaluation_cadastrale (nom_dossier, date_creation, date_validation, nom_evaluation_cadastrale, statut)
            VALUES (%s, %s, NOW(), %s, 'En attente')
        """, (dossier[1], dossier[2], nom_securisation))

        # Commit des changements dans la base de données
        mysql.connection.commit()
        cur.close()

        # Retourner à la page des dossiers de la sécurisation
        return redirect(url_for('liste_dossiers_assignes_securisation'))

    # Si le dossier n'est pas trouvé ou ne peut pas être validé
    return 'Dossier non trouvé ou statut invalide', 400

@app.route("/dossiers_securisation_valide")
def dossiers_securisation_valide():
    # Vérifier si l'utilisateur est connecté
    if 'email_securisation' not in session:
        return redirect(url_for('login'))

    # Récupérer les informations de la brigade connectée
    loggedIn, firstName = getLogin('email_securisation', 'securisation')
    if not loggedIn:
        return redirect(url_for('login'))
    
    cur = mysql.connection.cursor()
    
    # Identifier le chef de brigade connecté
    cur.execute("SELECT ident FROM securisation WHERE email_securisation = %s", [session['email_securisation']])
    securisation = cur.fetchone()
    if not securisation:
        flash("Erreur : securisation introuvable.")
        return redirect(url_for('login'))
    
    securisation_id = securisation[0]
    
    # Récupérer les dossiers avec le statut "Terminé" pour la brigade connectée
    cur.execute("""SELECT * FROM gestion_securisation WHERE securisation_id = %s AND statut = 'Terminé'""", [securisation_id])
    dossiers = cur.fetchall()
    cur.close()
    
    return render_template(
        "securisation/dossier/dossiers_valides.html",
        dossiers=dossiers,
        loggedIn=loggedIn,
        firstName=firstName
    )

@app.route("/securisation_tableau_de_bord")
def securisation_tableau_de_bord():
    if 'email_securisation' not in session:
        return redirect(url_for('login'))

    # Récupérer l'état de connexion et le prénom
    loggedIn, firstName = getLogin('email_securisation', 'securisation')
    if not loggedIn:
        return redirect(url_for('login'))
    
    cur = mysql.connection.cursor()
    cur.execute("SELECT ident FROM securisation WHERE email_securisation = %s", [session['email_securisation']])
    securisation = cur.fetchone()
    
    securisation_id = securisation[0]

    # Requêtes séparées pour chaque statut
    cur.execute("SELECT COUNT(*) FROM gestion_securisation WHERE statut = 'En attente'")
    en_attente = cur.fetchone()[0]

    cur.execute("SELECT COUNT(*) FROM gestion_securisation WHERE securisation_id = %s AND statut = 'En cours'", [securisation_id])
    en_cours = cur.fetchone()[0]

    cur.execute("SELECT COUNT(*) FROM gestion_securisation WHERE securisation_id = %s AND statut = 'Terminé'", [securisation_id])
    termine = cur.fetchone()[0]
    cur.close()
    return render_template('securisation/index.html',loggedIn=loggedIn, firstName=firstName,en_attente=en_attente, en_cours=en_cours,termine=termine)





###################evaluationcadastrale
@app.route("/inscription_evaluationcadastrale",methods=['POST', 'GET'])
def inscription_evaluationcadastrale():
    if request.method == 'POST':
        name = request.form['name']
        prenom = request.form['prenom']
        email = request.form['email']
        numero_telephone = request.form['numero_telephone']
        password = request.form['password']
        confirm_password = request.form['confirm_password']

        # Vérification de la confirmation de mot de passe
        if password != confirm_password:
            return "Les mots de passe ne correspondent pas. Veuillez réessayer."

        hashed_password = hashlib.md5(password.encode()).hexdigest()
        cursor = mysql.connection.cursor()
        
        cursor.execute("SELECT * FROM evaluation_cadastrale WHERE email_evaluationcadastrale = %s", (email,))
        existing_user = cursor.fetchone()

        if existing_user:
            flash("Cet email est déjà utilisé. Veuillez en utiliser un autre.", "danger")
            return redirect('/inscription_admin')

        try:
            cursor = mysql.connection.cursor()
            query = """INSERT INTO `evaluation_cadastrale` (name, prenom, email_evaluationcadastrale, numero_telephone, password) 
                       VALUES (%s, %s, %s, %s, %s)"""
            cursor.execute(query, (name, prenom, email, numero_telephone, hashed_password))
            mysql.connection.commit()
            return redirect('/')
        except Exception as e:
            return f"Erreur lors de l'inscription : {e}"
    return render_template('evaluation_cadastrale/connexion/cree_compte.html')

@app.route("/evaluationcadastrale_tableau_de_bord")
def evaluationcadastrale_tableau_de_bord():
    if 'email_evaluationcadastrale' not in session:
        return redirect(url_for('login'))

    # Récupérer l'état de connexion et le prénom
    loggedIn, firstName = getLogin('email_evaluationcadastrale', 'evaluation_cadastrale')
    if not loggedIn:
        return redirect(url_for('login'))
    
    
    
    cur = mysql.connection.cursor()
    cur.execute("SELECT ident FROM evaluation_cadastrale WHERE email_evaluationcadastrale = %s", [session['email_evaluationcadastrale']])
    evaluation_cadastrale = cur.fetchone()

    evaluation_cadastrale_id = evaluation_cadastrale[0]

    # Requêtes SQL pour chaque statut
    cur.execute("SELECT COUNT(*) FROM gestion_evaluation_cadastrale WHERE statut = 'En attente'")
    en_attente = cur.fetchone()[0]

    cur.execute("SELECT COUNT(*) FROM gestion_evaluation_cadastrale WHERE evaluation_cadastrale_id = %s AND statut = 'En cours'", [evaluation_cadastrale_id])
    en_cours = cur.fetchone()[0]

    cur.execute("SELECT COUNT(*) FROM gestion_evaluation_cadastrale WHERE evaluation_cadastrale_id = %s AND statut = 'Terminé'", [evaluation_cadastrale_id])
    termine = cur.fetchone()[0]
    cur.close()
    return render_template('evaluation_cadastrale/index.html',loggedIn=loggedIn, firstName=firstName, en_attente=en_attente, en_cours=en_cours, termine=termine)

@app.route("/liste_gestion_evaluationcadastrale")
def liste_gestion_evaluationcadastrale():
    # Vérifier si l'utilisateur est connecté comme un membre de la sécurisation
    if 'email_evaluationcadastrale' not in session:
        return redirect(url_for('login'))

    # Récupérer l'état de connexion et le prénom
    loggedIn, firstName = getLogin('email_evaluationcadastrale', 'evaluation_cadastrale')
    if not loggedIn:
        return redirect(url_for('login'))

    # Récupérer la liste de tous les dossiers dans gestion_securisation
    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT *
        FROM gestion_evaluation_cadastrale
        WHERE statut = 'En attente'
    """)
    dossiers = cur.fetchall()
    cur.close()

    return render_template(
        "evaluation_cadastrale/dossier/liste_gestion_eveluation_cadastrale.html",
        dossiers=dossiers,
        loggedIn=loggedIn,
        firstName=firstName
    )

@app.route("/assigner_dossier_evaluation_cadastrale/<int:dossier_id>", methods=["POST"])
def assigner_dossier_evaluation_cadastrale(dossier_id):
    # Vérifier si l'utilisateur est connecté comme un membre de la sécurisation
    if 'email_evaluationcadastrale' not in session:
        return redirect(url_for('login'))

    # Récupérer l'état de connexion et le prénom
    loggedIn, firstName = getLogin('email_evaluationcadastrale', 'evaluation_cadastrale')
    if not loggedIn:
        return redirect(url_for('login'))

    # Récupérer l'ID de la personne qui assigne
    cur = mysql.connection.cursor()
    cur.execute("SELECT ident FROM evaluation_cadastrale WHERE email_evaluationcadastrale = %s", [session['email_evaluationcadastrale']])
    evaluation_cadastrale_id = cur.fetchone()[0]

    # Assigner le dossier à la personne connectée et mettre à jour le statut
    cur.execute("""
        UPDATE gestion_evaluation_cadastrale
        SET evaluation_cadastrale_id = %s, statut = 'En cours'
        WHERE id = %s
    """, (evaluation_cadastrale_id, dossier_id))
    mysql.connection.commit()
    cur.close()

    flash("Dossier assigné avec succès.", "success")
    return redirect(url_for('liste_gestion_evaluationcadastrale'))

@app.route("/liste_dossiers_assignes_evaluation_cadastrale")
def liste_dossiers_assignes_evaluation_cadastrale():
    # Vérifier si l'utilisateur est connecté et est un membre de la sécurisation
    if 'email_evaluationcadastrale' not in session:
        return redirect(url_for('login'))

    # Récupérer l'email de l'utilisateur connecté et vérifier son statut
    loggedIn, firstName = getLogin('email_evaluationcadastrale', 'evaluation_cadastrale')
    if not loggedIn:
        return redirect(url_for('login'))

    # Récupérer les dossiers en cours pour cet utilisateur
    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT gsec.id, gsec.nom_dossier, gsec.date_creation, gsec.statut
        FROM gestion_evaluation_cadastrale gsec
        JOIN evaluation_cadastrale s ON gsec.evaluation_cadastrale_id = s.ident
        WHERE gsec.statut = 'En cours' AND s.email_evaluationcadastrale = %s
    """, [session['email_evaluationcadastrale']])
    dossiers = cur.fetchall()
    cur.close()
    return render_template( 
        "evaluation_cadastrale/dossier/liste_dossiers_assignes.html",
        dossiers=dossiers,
        loggedIn=loggedIn,
        firstName=firstName
    )

@app.route('/valider_dossier_evaluationcadastrale/<int:id_dossier>', methods=['POST'])
def valider_dossier_evaluationcadastrale(id_dossier):
    # Vérifier si l'utilisateur est connecté et est un membre de la sécurisation
    if 'email_evaluationcadastrale' not in session:
        return redirect(url_for('login'))

    # Récupérer l'email de l'utilisateur connecté et vérifier son statut
    loggedIn, firstName = getLogin('email_evaluationcadastrale', 'evaluation_cadastrale')
    if not loggedIn:
        return redirect(url_for('login'))
    
    cur = mysql.connection.cursor()
    cur.execute("SELECT ident, CONCAT(name, ' ', prenom) AS nom_evaluation_cadastrale FROM evaluation_cadastrale WHERE email_evaluationcadastrale = %s", 
                [session['email_evaluationcadastrale']])
    evaluation_cadastrale = cur.fetchone()
    evaluation_cadastrale_id = evaluation_cadastrale[0]
    nom_evaluation_cadastrale = evaluation_cadastrale[1]

    # Récupérer le dossier de la table gestion_signature
    cur = mysql.connection.cursor()
    
    
    cur.execute("""
        SELECT *
        FROM gestion_evaluation_cadastrale
        WHERE id = %s AND evaluation_cadastrale_id = %s
    """, (id_dossier, evaluation_cadastrale_id))
    dossier = cur.fetchone()

    if dossier:
        # Mise à jour du statut dans gestion_signature pour marquer le dossier comme terminé
        cur.execute("""
            UPDATE gestion_evaluation_cadastrale
            SET statut = 'Terminé'
            WHERE id = %s
        """, [id_dossier])

        # Insertion du dossier dans gestion_evaluation_cadastrale avec le nom du validateur
       
        
        cur.execute("""
        INSERT INTO gestion_signature (nom_dossier, date_creation, date_validation, nom_evaluation_cadastrale, statut)
            VALUES (%s, %s, NOW(), %s, 'En attente')
        """, (dossier[1], dossier[2], nom_evaluation_cadastrale))

        # Commit des changements dans la base de données
        mysql.connection.commit()
        cur.close()

        # Retourner à la page des dossiers de la sécurisation
        return redirect(url_for('liste_dossiers_assignes_evaluation_cadastrale'))

    # Si le dossier n'est pas trouvé ou ne peut pas être validé
    return 'Dossier non trouvé ou statut invalide', 400

@app.route("/dossiers_Evaluation_cadastral_valide")
def dossiers_Evaluation_cadastral_valide():
    # Vérifier si l'utilisateur est connecté
    if 'email_evaluationcadastrale' not in session:
        return redirect(url_for('login'))

    # Récupérer les informations de la brigade connectée
    loggedIn, firstName = getLogin('email_evaluationcadastrale', 'evaluation_cadastrale')
    if not loggedIn:
        return redirect(url_for('login'))
    
    cur = mysql.connection.cursor()
    
    # Identifier le chef de brigade connecté
    cur.execute("SELECT ident FROM evaluation_cadastrale WHERE email_evaluationcadastrale = %s", [session['email_evaluationcadastrale']])
    evaluation_cadastrale = cur.fetchone()
    if not evaluation_cadastrale:
        flash("Erreur : evaluation_cadastrale introuvable.")
        return redirect(url_for('login'))
    
    evaluation_cadastrale_id = evaluation_cadastrale[0]
    
    # Récupérer les dossiers avec le statut "Terminé" pour la brigade connectée
    cur.execute("""SELECT * FROM gestion_evaluation_cadastrale WHERE evaluation_cadastrale_id = %s AND statut = 'Terminé'""", [evaluation_cadastrale_id])
    dossiers = cur.fetchall()
    cur.close()
    
    return render_template(
        "evaluation_cadastrale/dossier/dossiers_valides.html",
        dossiers=dossiers,
        loggedIn=loggedIn,
        firstName=firstName
    )







###################Signature
@app.route("/inscription_signature",methods=['POST', 'GET'])
def inscription_signature():
    if request.method == 'POST':
        name = request.form['name']
        prenom = request.form['prenom']
        email = request.form['email']
        numero_telephone = request.form['numero_telephone']
        password = request.form['password']
        confirm_password = request.form['confirm_password']

        # Vérification de la confirmation de mot de passe
        if password != confirm_password:
            return "Les mots de passe ne correspondent pas. Veuillez réessayer."

        hashed_password = hashlib.md5(password.encode()).hexdigest()
        cursor = mysql.connection.cursor()
        
        cursor.execute("SELECT * FROM signature WHERE email_signature = %s", (email,))
        existing_user = cursor.fetchone()

        if existing_user:
            flash("Cet email est déjà utilisé. Veuillez en utiliser un autre.", "danger")
            return redirect('/inscription_admin')

        try:
            cursor = mysql.connection.cursor()
            query = """INSERT INTO `signature` (name, prenom, email_signature, numero_telephone, password) 
                       VALUES (%s, %s, %s, %s, %s)"""
            cursor.execute(query, (name, prenom, email, numero_telephone, hashed_password))
            mysql.connection.commit()
            return redirect('/')
        except Exception as e:
            return f"Erreur lors de l'inscription : {e}"
    return render_template('signature/connexion/cree_compte.html')

@app.route("/signature_fonciere_tableau_de_bord")
def signature_fonciere_tableau_de_bord():
    if 'email_signature' not in session:
        return redirect(url_for('login'))

    # Récupérer l'état de connexion et le prénom
    loggedIn, firstName = getLogin('email_signature', 'signature')
    if not loggedIn:
        return redirect(url_for('login'))
    
    
    cur = mysql.connection.cursor()
    cur.execute("SELECT ident FROM signature WHERE email_signature = %s", [session['email_signature']])
    signature = cur.fetchone()

    signature_id = signature[0]

    # Requêtes SQL pour chaque statut
    cur.execute("SELECT COUNT(*) FROM gestion_signature WHERE statut = 'En attente'")
    en_attente = cur.fetchone()[0]

    cur.execute("SELECT COUNT(*) FROM gestion_signature WHERE signature_id = %s AND statut = 'En cours'", [signature_id])
    en_cours = cur.fetchone()[0]

    cur.execute("SELECT COUNT(*) FROM gestion_signature WHERE signature_id = %s AND statut = 'Terminé'", [signature_id])
    termine = cur.fetchone()[0]
    cur.close()
    return render_template('signature/index.html',firstName=firstName,en_attente=en_attente,en_cours=en_cours,termine=termine)



@app.route("/liste_gestion_signature")
def liste_gestion_signature():
    # Vérifier si l'utilisateur est connecté comme un membre de la sécurisation
    if 'email_signature' not in session:
        return redirect(url_for('login'))

    # Récupérer l'état de connexion et le prénom
    loggedIn, firstName = getLogin('email_signature', 'signature')
    if not loggedIn:
        return redirect(url_for('login'))

    # Récupérer la liste de tous les dossiers dans gestion_securisation
    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT *
        FROM gestion_signature
        WHERE statut = 'En attente'
    """)
    dossiers = cur.fetchall()
    cur.close()

    return render_template(
        "signature/dossier/liste_gestion_signature.html",
        dossiers=dossiers,
        loggedIn=loggedIn,
        firstName=firstName
    )

@app.route("/assigner_dossier_signature/<int:dossier_id>", methods=["POST"])
def assigner_dossier_signature(dossier_id):
    # Vérifier si l'utilisateur est connecté comme un membre de la sécurisation
    if 'email_signature' not in session:
        return redirect(url_for('login'))

    # Récupérer l'état de connexion et le prénom
    loggedIn, firstName = getLogin('email_signature', 'signature')
    if not loggedIn:
        return redirect(url_for('login'))


    # Récupérer l'ID de la personne qui assigne
    cur = mysql.connection.cursor()
    cur.execute("SELECT ident FROM signature WHERE email_signature = %s", [session['email_signature']])
    signature_id = cur.fetchone()[0]

    # Assigner le dossier à la personne connectée et mettre à jour le statut
    cur.execute("""
        UPDATE gestion_signature
        SET signature_id = %s, statut = 'En cours'
        WHERE id = %s
    """, (signature_id, dossier_id))
    mysql.connection.commit()
    cur.close()

    flash("Dossier assigné avec succès.", "success")
    return redirect(url_for('liste_gestion_signature'))

@app.route("/liste_dossiers_assignes_signature")
def liste_dossiers_assignes_signature():
    # Vérifier si l'utilisateur est connecté et est un membre de la sécurisation
    if 'email_signature' not in session:
        return redirect(url_for('login'))

    # Récupérer l'état de connexion et le prénom
    loggedIn, firstName = getLogin('email_signature', 'signature')
    if not loggedIn:
        return redirect(url_for('login'))
    # Récupérer les dossiers en cours pour cet utilisateur
    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT gss.id, gss.nom_dossier, gss.date_creation, gss.statut
        FROM gestion_signature gss
        JOIN signature s ON gss.signature_id = s.ident
        WHERE gss.statut = 'En cours' AND s.email_signature = %s
    """, [session['email_signature']])
    dossiers = cur.fetchall()
    cur.close()
    return render_template( 
        "signature/dossier/liste_dossiers_assignes_signature.html",
        dossiers=dossiers,
        loggedIn=loggedIn,
        firstName=firstName
    )
    
@app.route('/valider_dossier_signature/<int:id_dossier>', methods=['POST'])
def valider_dossier_signature(id_dossier):
    # Vérifier si l'utilisateur est connecté et est un membre de la sécurisation
    if 'email_signature' not in session:
        return redirect(url_for('login'))

    # Récupérer l'état de connexion et le prénom
    loggedIn, firstName = getLogin('email_signature', 'signature')
    if not loggedIn:
        return redirect(url_for('login'))
    
    cur = mysql.connection.cursor()
    cur.execute("SELECT ident, CONCAT(name, ' ', prenom) AS nom_signature FROM signature WHERE email_signature = %s", 
                [session['email_signature']])
    signature = cur.fetchone()
    signature_id = signature[0]
    nom_signature = signature[1]

    # Récupérer le dossier de la table gestion_signature
    cur = mysql.connection.cursor()
    
    
    cur.execute("""
        SELECT *
        FROM gestion_signature
        WHERE id = %s AND signature_id = %s
    """, (id_dossier, signature_id))
    dossier = cur.fetchone()

    if dossier:
        # Mise à jour du statut dans gestion_signature pour marquer le dossier comme terminé
        cur.execute("""
            UPDATE gestion_signature
            SET statut = 'Terminé'
            WHERE id = %s
        """, [id_dossier])

        # Insertion du dossier dans gestion_evaluation_cadastrale avec le nom du validateur
       
        
        cur.execute("""
        INSERT INTO gestion_fonciere (nom_dossier, date_creation, date_validation, nom_signature, statut)
            VALUES (%s, %s, NOW(), %s, 'En attente')
        """, (dossier[1], dossier[2], nom_signature))

        # Commit des changements dans la base de données
        mysql.connection.commit()
        cur.close()

        # Retourner à la page des dossiers de la sécurisation
        return redirect(url_for('liste_dossiers_assignes_signature'))

    # Si le dossier n'est pas trouvé ou ne peut pas être validé
    return 'Dossier non trouvé ou statut invalide', 400

@app.route("/dossiers_signature_valide")
def dossiers_signature_valide():
    # Vérifier si l'utilisateur est connecté
    if 'email_signature' not in session:
        return redirect(url_for('login'))

    # Récupérer les informations de la brigade connectée
    loggedIn, firstName = getLogin('email_signature', 'signature')
    if not loggedIn:
        return redirect(url_for('login'))
    
    cur = mysql.connection.cursor()
    
    # Identifier le chef de brigade connecté
    cur.execute("SELECT ident FROM signature WHERE email_signature = %s", [session['email_signature']])
    signature = cur.fetchone()
    if not signature:
        flash("Erreur : signature introuvable.")
        return redirect(url_for('login'))
    
    signature_id = signature[0]
    
    # Récupérer les dossiers avec le statut "Terminé" pour la brigade connectée
    cur.execute("""SELECT * FROM gestion_signature WHERE signature_id = %s AND statut = 'Terminé'""", [signature_id])
    dossiers = cur.fetchall()
    cur.close()
    
    return render_template(
        "signature/dossier/dossiers_valides.html",
        dossiers=dossiers,
        loggedIn=loggedIn,
        firstName=firstName
    )










###################conversationfonciere
@app.route("/inscription_conversationfonciere",methods=['POST', 'GET'])
def inscription_conversationfonciere():
    if request.method == 'POST':
        name = request.form['name']
        prenom = request.form['prenom']
        email = request.form['email']
        numero_telephone = request.form['numero_telephone']
        password = request.form['password']
        confirm_password = request.form['confirm_password']

        # Vérification de la confirmation de mot de passe
        if password != confirm_password:
            return "Les mots de passe ne correspondent pas. Veuillez réessayer."

        hashed_password = hashlib.md5(password.encode()).hexdigest()
        cursor = mysql.connection.cursor()
        
        cursor.execute("SELECT * FROM conversation_fonciere WHERE email_conversationfonciere = %s", (email,))
        existing_user = cursor.fetchone()

        if existing_user:
            flash("Cet email est déjà utilisé. Veuillez en utiliser un autre.", "danger")
            return redirect('/inscription_admin')

        try:
            cursor = mysql.connection.cursor()
            query = """INSERT INTO `conversation_fonciere` (name, prenom, email_conversationfonciere, numero_telephone, password) 
                       VALUES (%s, %s, %s, %s, %s)"""
            cursor.execute(query, (name, prenom, email, numero_telephone, hashed_password))
            mysql.connection.commit()
            return redirect('/')
        except Exception as e:
            return f"Erreur lors de l'inscription : {e}"
    return render_template('conversation_fonciere/connexion/cree_compte.html')

@app.route("/conversation_fonciere_tableau_de_bord")
def conversation_fonciere_tableau_de_bord():
    if 'email_conversationfonciere' not in session:
        return redirect(url_for('login'))

    # Récupérer l'état de connexion et le prénom
    loggedIn, firstName = getLogin('email_conversationfonciere', 'conversation_fonciere')
    if not loggedIn:
        return redirect(url_for('login'))
    return render_template('conversation_fonciere/index.html')

@app.route("/liste_gestion_fonciere")
def liste_gestion_fonciere():
    # Vérifier si l'utilisateur est connecté comme un membre de la sécurisation
    if 'email_conversationfonciere' not in session:
        return redirect(url_for('login'))

    # Récupérer l'état de connexion et le prénom
    loggedIn, firstName = getLogin('email_conversationfonciere', 'conversation_fonciere')
    if not loggedIn:
        return redirect(url_for('login'))

    # Récupérer la liste de tous les dossiers dans gestion_securisation
    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT *
        FROM gestion_fonciere
        WHERE statut = 'En attente'
    """)
    dossiers = cur.fetchall()
    cur.close()

    return render_template(
        "conversation_fonciere/dossier/liste_gestion_fonciere.html",
        dossiers=dossiers,
        loggedIn=loggedIn,
        firstName=firstName
    )

@app.route("/assigner_dossier_fonciere/<int:dossier_id>", methods=["POST"])
def assigner_dossier_fonciere(dossier_id):
    # Vérifier si l'utilisateur est connecté comme un membre de la sécurisation
    if 'email_conversationfonciere' not in session:
        return redirect(url_for('login'))

    # Récupérer l'état de connexion et le prénom
    loggedIn, firstName = getLogin('email_conversationfonciere', 'conversation_fonciere')
    if not loggedIn:
        return redirect(url_for('login'))


    # Récupérer l'ID de la personne qui assigne
    cur = mysql.connection.cursor()
    cur.execute("SELECT ident FROM conversation_fonciere WHERE email_conversationfonciere = %s", [session['email_conversationfonciere']])
    fonciere_id = cur.fetchone()[0]

    # Assigner le dossier à la personne connectée et mettre à jour le statut
    cur.execute("""
        UPDATE gestion_fonciere
        SET fonciere_id = %s, statut = 'En cours'
        WHERE id = %s
    """, (fonciere_id, dossier_id))
    mysql.connection.commit()
    cur.close()

    flash("Dossier assigné avec succès.", "success")
    return redirect(url_for('liste_gestion_fonciere'))

@app.route("/liste_dossiers_assignes_fonciere")
def liste_dossiers_assignes_fonciere():
    # Vérifier si l'utilisateur est connecté et est un membre de la sécurisation
    if 'email_conversationfonciere' not in session:
        return redirect(url_for('login'))

    # Récupérer l'état de connexion et le prénom
    loggedIn, firstName = getLogin('email_conversationfonciere', 'conversation_fonciere')
    if not loggedIn:
        return redirect(url_for('login'))
    # Récupérer les dossiers en cours pour cet utilisateur
    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT gss.id, gss.nom_dossier, gss.date_creation, gss.statut
        FROM gestion_fonciere gss
        JOIN conversation_fonciere s ON gss.fonciere_id = s.ident
        WHERE gss.statut = 'En cours' AND s.email_conversationfonciere = %s
    """, [session['email_conversationfonciere']])
    dossiers = cur.fetchall()
    cur.close()
    return render_template( 
        "conversation_fonciere/dossier/liste_dossiers_assignes_fonciere.html",
        dossiers=dossiers,
        loggedIn=loggedIn,
        firstName=firstName
    )

@app.route("/fin_dossier_fonciere/<int:id_dossier>", methods=["POST"])
def fin_dossier_fonciere(id_dossier):
    # Vérifier si l'utilisateur est connecté comme un membre de la sécurisation
    if 'email_conversationfonciere' not in session:
        return redirect(url_for('login'))

    # Récupérer l'état de connexion et le prénom
    loggedIn, firstName = getLogin('email_conversationfonciere', 'conversation_fonciere')
    if not loggedIn:
        return redirect(url_for('login'))

    # Récupérer l'utilisateur connecté
    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT ident, name, prenom 
        FROM conversation_fonciere 
        WHERE email_conversationfonciere = %s
    """, [session['email_conversationfonciere']])
    fonciere_user = cur.fetchone()
    fonciere_id = fonciere_user[0]
    validateur = f"{fonciere_user[1]} {fonciere_user[2]}"

    # Assigner le dossier à la personne connectée, mettre à jour le statut et enregistrer le validateur
    cur.execute("""
        UPDATE gestion_fonciere
        SET fonciere_id = %s, statut = 'Terminé', validateur = %s
        WHERE id = %s
    """, (fonciere_id, validateur, id_dossier))
    mysql.connection.commit()
    cur.close()

    flash("Dossier assigné et validé avec succès.", "success")
    return redirect(url_for('liste_gestion_fonciere'))

@app.route("/dossiers_fonciere_valide")
def dossiers_fonciere_valide():
    # Vérifier si l'utilisateur est connecté
    if 'email_conversationfonciere' not in session:
        return redirect(url_for('login'))

    # Récupérer les informations de la brigade connectée
    loggedIn, firstName = getLogin('email_conversationfonciere', 'conversation_fonciere')
    if not loggedIn:
        return redirect(url_for('login'))
    
    cur = mysql.connection.cursor()
    
    # Identifier le chef de brigade connecté
    cur.execute("SELECT ident FROM conversation_fonciere WHERE email_conversationfonciere = %s", [session['email_conversationfonciere']])
    conversation_fonciere = cur.fetchone()
    if not conversation_fonciere:
        flash("Erreur : conversation_fonciere introuvable.")
        return redirect(url_for('login'))
    
    fonciere_id = conversation_fonciere[0]
    
    # Récupérer les dossiers avec le statut "Terminé" pour la brigade connectée
    cur.execute("""SELECT * FROM gestion_fonciere WHERE fonciere_id = %s AND statut = 'Terminé'""", [fonciere_id])
    dossiers = cur.fetchall()
    cur.close()
    
    return render_template(
        "conversation_fonciere/dossier/dossiers_valides.html",
        dossiers=dossiers,
        loggedIn=loggedIn,
        firstName=firstName
    )






#####******************* login
@app.route('/', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        print(email)
        print(password)

        # Vérification des informations
        if is_valid(email, 'email_chefbrigade', password, 'chef_brigade'):
            session['email_chefbrigade'] = email
            flash('Connexion réussie !', 'success')
            return redirect(url_for('chef_brigade_tableau_de_bord'))
        elif is_valid(email, "email_brigade", password, "brigade"):
            session['email_brigade'] = email
            return redirect(url_for('brigade_tableau_de_bord'))
        elif is_valid(email, "email_conversationfonciere", password, "conversation_fonciere"):
            session['email_conversationfonciere'] = email
            return redirect(url_for('conversation_fonciere_tableau_de_bord'))
        elif is_valid(email, "email_securisation", password, "securisation"):
            session['email_securisation'] = email
            return redirect(url_for('securisation_tableau_de_bord'))
        elif is_valid(email, "email_evaluationcadastrale", password, "evaluation_cadastrale"):
            session['email_evaluationcadastrale'] = email
            return redirect(url_for('evaluationcadastrale_tableau_de_bord'))
        elif is_valid(email, "email_signature", password, "signature"):
            session['email_signature'] = email
            return redirect(url_for('signature_fonciere_tableau_de_bord'))
        elif is_valid(email, "email_admin", password, "admin"):
            session['email_admin'] = email
            return redirect(url_for('admin_tableau_de_bord'))
        else:
            flash('Email ou mot de passe incorrect.', 'danger')
            return redirect(url_for('login'))
    return render_template('login.html')




#####******************* Mot de passe oublié
@app.route('/forgot_password', methods=['GET', 'POST'])
def forgot_password():
    if request.method == 'POST':
        email = request.form['email']

        # Dictionnaire des tables et des colonnes d'email
        tables = {
            "chef_brigade": "email_chefbrigade",
            "brigade": "email_brigade",
            "securisation": "email_securisation",
            "evaluation_cadastrale": "email_evaluationcadastrale",
            "signature": "email_signature",
            "conversation_fonciere": "email_conversationfonciere"
        }

        cursor = mysql.connection.cursor()
        user = None
        table_name = None
        column_name = None

        # Parcourir chaque table et vérifier si l'email existe
        for table, email_column in tables.items():
            query = f"SELECT * FROM {table} WHERE {email_column} = %s"
            cursor.execute(query, (email,))
            user = cursor.fetchone()
            if user:
                table_name = table
                column_name = email_column
                break

        if user:
            # Générer un token de réinitialisation unique
            reset_token = secrets.token_hex(16)
            token_expiration = datetime.now() + timedelta(hours=1)

            # Enregistrer le token dans la table correspondante
            update_query = f"""
                UPDATE {table_name}
                SET reset_token = %s, token_expiration = %s
                WHERE {column_name} = %s
            """
            cursor.execute(update_query, (reset_token, token_expiration, email))
            mysql.connection.commit()

            # Générer et envoyer le lien de réinitialisation
            reset_link = url_for('reset_password', token=reset_token, table=table_name, _external=True)
            msg = Message(
                "Réinitialisation de votre mot de passe",
                recipients=[email]
            )
            msg.body = f"Bonjour, cliquez sur le lien suivant pour réinitialiser votre mot de passe : {reset_link}"
            mail.send(msg)

            flash("Un email avec un lien de réinitialisation a été envoyé à votre adresse email.")
            return redirect('/')
        
        flash("Cet email n'existe pas dans notre système.")
        return redirect('/forgot_password')

    return render_template('mot_de passe_oublier/mot_de_passe_oublier.html')


@app.route('/reset_password/<table>/<token>', methods=['GET', 'POST'])
def reset_password(table, token):
    # Dictionnaire des colonnes d'email pour chaque table
    email_columns = {
        "chef_brigade": "email_chefbrigade",
        "brigade": "email_brigade",
        "securisation": "email_securisation",
        "evaluation_cadastrale": "email_evaluationcadastrale",
        "signature": "email_signature",
        "conversation_fonciere": "email_conversationfonciere"
    }

    if table not in email_columns:
        flash("Table invalide.")
        return redirect('/forgot_password')

    email_column = email_columns[table]
    cursor = mysql.connection.cursor()

    # Vérifier le token et sa validité
    query = f"""
        SELECT * FROM {table} 
        WHERE reset_token = %s AND token_expiration > NOW()
    """
    cursor.execute(query, (token,))
    user = cursor.fetchone()

    if not user:
        flash("Le lien de réinitialisation est invalide ou a expiré.")
        return redirect('/forgot_password')

    if request.method == 'POST':
        new_password = request.form['password']
        confirm_password = request.form['confirm_password']

        if new_password != confirm_password:
            flash("Les mots de passe ne correspondent pas. Veuillez réessayer.")
            return redirect(request.url)

        # Hacher le nouveau mot de passe
        hashed_password = hashlib.md5(new_password.encode()).hexdigest()

        # Mettre à jour le mot de passe et réinitialiser les colonnes de token
        update_query = f"""
            UPDATE {table} 
            SET password = %s, reset_token = NULL, token_expiration = NULL
            WHERE reset_token = %s
        """
        cursor.execute(update_query, (hashed_password, token))
        mysql.connection.commit()

        flash("Votre mot de passe a été réinitialisé avec succès.")
        return redirect('/')

    return render_template('mot_de passe_oublier/reinitialiser_mot_de_passe.html', table=table, token=token)




if __name__ == "__main__":
    app.run(debug=True)