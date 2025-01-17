import secrets
from flask import *
from flask_mysqldb import MySQL
import  hashlib
from credentials  import*
from datetime import datetime
from dateutil.relativedelta import relativedelta
from flask_mail import Mail, Message
from datetime import datetime, timedelta
from MySQLdb.cursors import DictCursor
from datetime import datetime
from dateutil.relativedelta import relativedelta


app = Flask(__name__)
app.config['SECRET_KEY']=my_token
app.config['MYSQL_HOST'] = my_host
app.config['MYSQL_USER'] = my_user
app.config['MYSQL_PASSWORD'] = my_password
app.config['MYSQL_DB'] =  my_db
app.config['MYSQL_CURSORCLASS'] =my_CURSORCLASS




app.config['MAIL_SERVER'] = 'mail.alabdigital.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_DEFAULT_SENDER'] = 'support_alabdigital@alabdigital.com'
app.config['MAIL_USERNAME'] = 'support_alabdigital@alabdigital.com'
app.config['MAIL_PASSWORD'] = 't$sZm$Z7m~rt.tO2_s@TGVd_alabdigital@alabdig'
mail = Mail(app)
mysql = MySQL()
mysql.init_app(app)


now = datetime.now()
date_now= now.strftime("%Y-%m-%d %H:%M:%S")


def calculer_difference(date1_str, date2_str):
    date1 = datetime.strptime(date1_str, '%Y-%m-%d %H:%M:%S')
    date2 = datetime.strptime(date2_str, '%Y-%m-%d %H:%M:%S')
    delta = date1 - date2
    total_jours = delta.days
    mois, jours = divmod(total_jours, 30)  # Approximation : un mois = 30 jours
    heures, reste_secondes = divmod(delta.seconds, 3600)
    minutes, _ = divmod(reste_secondes, 60)
    return f"mois: {mois}, jours: {jours}, heures: {heures}, minutes: {minutes}"





###################### Dossier
def getLogin(email, table):
    cur = mysql.connection.cursor()
    if email not in session:
        loggedIn = False
        firstName = ''
    else:
        loggedIn = True
        cur.execute("SELECT ident, nom_complet FROM " + table + " WHERE " + email + " = '" + session[email] + "'")
        useradminID, firstName = cur.fetchone()

    cur.close()
    return useradminID, firstName

# Fonction is_valid
def is_valid(email, email_t, password, table):
    cur = mysql.connection.cursor()
    cur.execute('SELECT {}, password FROM {}'.format(email_t, table))
    data = cur.fetchall()
    for row in data:
        if row[0] == str(email) and row[1] == hashlib.md5(password.encode()).hexdigest():
            return True
    return False


from datetime import datetime

def get_pending_count(table_name, statut):
    cur = mysql.connection.cursor()
    current_year = datetime.now().year
    query = f"""
        SELECT COUNT(*) 
        FROM {table_name} 
        WHERE statut = %s 
        AND YEAR(date_ajout) = %s
    """
    cur.execute(query, (statut, current_year))
    result = cur.fetchone()
    return result[0] if result else 0


def get_objectif_count(colonne):
    cur = mysql.connection.cursor()
    query = f"SELECT {colonne} FROM objectifs_direction"
    cur.execute(query)
    result = cur.fetchone()
    return result[0] if result else 0


def get_count(table_name):
    cur = mysql.connection.cursor()
    query = f"SELECT COUNT(*) FROM {table_name}"
    cur.execute(query)
    result = cur.fetchone()
    return result[0] if result else 0



@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('login'))






@app.route("/inscription_admin",methods=['POST', 'GET'])
def inscription_admin():
    if 'email_admin' not in session:
        return redirect(url_for('login'))
    else:
        loggedIn, firstName = getLogin('email_admin', 'admin')
        if request.method == 'POST':
            name = request.form['name']
            prenom = request.form['prenom']
            nom_complet = name + ' ' +  prenom
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
                return redirect('inscription_admin')

            try:
                cursor = mysql.connection.cursor()
                query = """INSERT INTO `admin` (nom_complet, email_admin, numero_telephone, password) 
                        VALUES (%s, %s, %s, %s)"""
                cursor.execute(query, (name, prenom, email, numero_telephone, hashed_password))
                mysql.connection.commit()
                return redirect('login')
            except Exception as e:
                return f"Erreur lors de l'inscription : {e}"
        return render_template('admin/connexion/cree_compte.html', firstName=firstName)





@app.route("/rechercher", methods=["GET", "POST"])
def rechercher_dossier():
    if request.method == "POST":
        nom_dossier = request.form.get("nom_dossier")
        if not nom_dossier:
            return render_template(
                "admin/dossier/recherche_trouver.html",
                error="Veuillez saisir un nom de dossier.",
                dossiers=None
            )

        tables = [
            "gestion_chef_brigade", "gestion_brigade", "gestion_securisation",
            "gestion_evaluation_cadastrale", "gestion_signature", "gestion_conversation_fonciere",
            "gestion_conversation_fonciere_terminer"
        ]
        dossiers = []

        # Fonction pour formater le nom de la table
        def format_table_name(table_name):
            table_name = table_name.replace("gestion_", "")  # Enlever 'gestion_'
            table_name = table_name.replace("_", " ").capitalize()  # Remplacer le _ par un espace et mettre en majuscule
            return table_name

        cur = mysql.connection.cursor()
        try:
            for table in tables:
                query = f"SELECT * FROM {table} WHERE nom_dossier LIKE %s"
                cur.execute(query, (f"%{nom_dossier}%",))
                results = cur.fetchall()
                columns = [desc[0] for desc in cur.description]  # Récupérer les noms des colonnes

                for result in results:
                    dossier = {"table": format_table_name(table)}  # Formater le nom de la table ici
                    for idx, column in enumerate(columns):
                        dossier[column] = result[idx] if idx < len(result) else None  # Ajouter uniquement les colonnes existantes
                    dossiers.append(dossier)

            # Fonction pour extraire les dates et trouver la date maximale
            def get_max_date(row):
                dates = []

                # Parcourir les clés du dictionnaire pour trouver les colonnes "date"
                for column, value in row.items():
                    if column.lower().startswith('date_') and isinstance(value, datetime):
                        dates.append(value)

                # Trouver la date maximale
                if dates:
                    return max(dates)
                return None

            # Calculer la différence en mois, jours, heures, minutes et secondes pour chaque dossier
            for dossier in dossiers:
                max_date = get_max_date(dossier)
                if max_date and 'date_ajout' in dossier and isinstance(dossier['date_ajout'], datetime):
                    # Calculer la différence
                    delta = relativedelta(max_date, dossier['date_ajout'])

                    # Calcul des mois, jours, heures, minutes et secondes
                    mois = delta.years * 12 + delta.months
                    jours = delta.days
                    heures = max_date.hour - dossier['date_ajout'].hour
                    minutes = max_date.minute - dossier['date_ajout'].minute
                    secondes = max_date.second - dossier['date_ajout'].second

                    # Corriger les heures, minutes et secondes négatives
                    if secondes < 0:
                        secondes += 60
                        minutes -= 1
                    if minutes < 0:
                        minutes += 60
                        heures -= 1
                    if heures < 0:
                        heures += 24
                        jours -= 1

                    dossier['duree_mois'] = mois
                    dossier['duree_jours'] = jours
                    dossier['duree_heures'] = heures
                    dossier['duree_minutes'] = minutes
                    dossier['duree_secondes'] = secondes

            return render_template(
                "admin/dossier/recherche_trouver.html",
                dossiers=dossiers,
                nom_dossier=nom_dossier,
                error=None
            )
        except Exception as e:
            return render_template(
                "admin/dossier/recherche_trouver.html",
                error=f"Erreur : {str(e)}",
                dossiers=None
            )
        finally:
            cur.close()
    return render_template("admin/dossier/recherche_trouver.html", dossiers=None, error=None)



@app.route("/admin_tableau_de_bord")
def admin_tableau_de_bord():
    # Vérification de la session pour s'assurer que l'administrateur est connecté
    if 'email_admin' not in session:
        return redirect(url_for('login'))
    # Obtenir les informations de connexion de l'administrateur
    loggedIn, firstName = getLogin('email_admin', 'admin')

    liste_table_gestion=["gestion_chef_brigade", "gestion_brigade",
                         "gestion_securisation", "gestion_evaluation_cadastrale",
                         "gestion_signature", "gestion_conversation_fonciere"]

    liste_table_terminer=["gestion_chef_brigade_terminer", "gestion_brigade_terminer",
                          "gestion_securisation_terminer", "gestion_evaluation_cadastrale_terminer",
                          "gestion_signature_terminer", "gestion_conversation_fonciere_terminer"]

    liste_table_terminer_ter=["gestion_conversation_fonciere_terminer"]
    attente_liste    = [get_pending_count(row, 'En attente') for row in liste_table_gestion]
    en_cours_liste = [get_pending_count(row, "En cours")   for row in liste_table_gestion]
    terminer_liste = [get_pending_count(row, "Terminé")   for row in liste_table_terminer]
    terminer_liste_ter = [get_pending_count(row, "Terminé")   for row in liste_table_terminer_ter]

    print(terminer_liste_ter)
    nombre_attente   =  sum(attente_liste)
    nombre_cours     =  sum(en_cours_liste)
    nombre_terminer  =  sum(terminer_liste_ter)


    liste_table    = ["chef_brigade", "brigade", "securisation",
                      "evaluation_cadastrale","signature", "conversation_fonciere"]

    liste_personnel  = [get_count(row) for row in liste_table]
    nombre_personnel = sum(liste_personnel)
    combined_data    = zip(liste_table, attente_liste, en_cours_liste, terminer_liste, liste_personnel)

    directions = [
        {
            "name": objectif,
            "termine": terminer,
            "objectif": get_objectif_count(objectif)
        } for objectif, terminer in  zip(liste_table,terminer_liste )

    ]

    # Calcul du pourcentage de réalisation
    for direction in directions:
        direction["pourcentage"] = (direction["termine"] / direction["objectif"]) * 100

    # Identifier la meilleure direction
    meilleure_direction = max(directions, key=lambda x: x["pourcentage"])



    return render_template(
        'admin/index.html',
        firstName=firstName,
        nombre_attente=nombre_attente,
        nombre_cours=nombre_cours,
        nombre_terminer=nombre_terminer,
        liste_table=liste_table,
        combined_data=combined_data,
        nombre_personnel=nombre_personnel,
        directions=directions,
        meilleure_direction=meilleure_direction)


@app.route('/ajouter_dossier', methods=['GET', 'POST'])
def ajouter_dossier():
    if 'email_admin' not in session:
        return redirect(url_for('login'))
    # Récupérer les informations du chef de brigade connecté
    loggedIn, firstName = getLogin('email_admin', 'admin')
    if not loggedIn:
        return redirect(url_for('login'))
    if request.method == 'POST':
        nom_dossier = request.form['nom']
        statut = 'attente'  # Le statut est toujours 'attente' par défaut
        cur = mysql.connection.cursor()
        cur.execute("""INSERT INTO dossier (nom_dossier,date_creation,statut,nom_de_ajouteur) VALUES (%s, %s, %s,%s)""", (nom_dossier,date_now,statut,firstName))
        mysql.connection.commit()
        cur.close()
        return redirect(url_for('liste_dossier'))

    return render_template('admin/dossier/ajout_dossier.html', firstName=firstName)

# Route pour modifier un produit
@app.route('/modifier_dossier/<int:id>', methods=['GET', 'POST'])
def modifier_dossier(id):
    if 'email_admin' in session:
        # Vérification de la session et récupération des informations d'utilisateur
        loggedIn, firstName = getLogin('email_admin', 'admin')
        cur = mysql.connection.cursor()

        # Récupération du dossier à modifier
        cur.execute("SELECT * FROM dossier WHERE id = %s", (id,))
        dossier = cur.fetchone()
        if request.method == 'POST':
            # Extraction du nom du dossier et validation
            nom_dossier = request.form.get('nom', '').strip()

            # Vérifier si le dossier avec le même nom existe déjà
            cur.execute("SELECT * FROM dossier WHERE nom_dossier = %s", (nom_dossier,))
            existing_dossier = cur.fetchone()

            if existing_dossier:
                flash("Un dossier avec ce nom existe déjà.", "danger")
                return redirect(url_for('modifier_dossier', id=id))

            # Mise à jour du dossier si aucune erreur
            else:
                try:
                    date_now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
                    cur.execute("""
                        UPDATE dossier 
                        SET nom_dossier = %s, date_creation = %s, statut = %s, nom_de_ajouteur = %s
                        WHERE id = %s""", (nom_dossier, date_now, 'attente', firstName, id))
                    mysql.connection.commit()
                    flash("Modification réussie avec succès 👍", "success")
                    return redirect(url_for('liste_dossier'))
                except Exception as e:
                    mysql.connection.rollback()
                    flash(f"Erreur lors de la mise à jour du dossier : {e}", "danger")

        return render_template('admin/dossier/modifier_dossier.html', firstName=firstName, dossier=dossier)
    else:
        return redirect(url_for('login'))


# Route pour supprimer un produit
@app.route('/supprimer/<int:id>')
def supprimer_dossier(id):
    if 'email_admin' in session:
        loggedIn, firstName = getLogin('email_admin', 'admin')
        cur = mysql.connection.cursor()
        cur.execute("DELETE from dossier WHERE id=%s", (id,))
        mysql.connection.commit()
        cur.close()
        flash('Produit supprimé avec succès!','succès')
        return redirect(url_for('liste_dossier'))
    else:
        return redirect(url_for('login'))

@app.route("/liste_dossier")
def liste_dossier():
    loggedIn, firstName = getLogin('email_admin', 'admin')
    if 'email_admin' not in session:
        return redirect(url_for('login'))
    else:
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM dossier  ORDER BY `dossier`.`id` DESC")  # Vous pouvez ajuster cette requête si vous avez des filtres
        dossiers = cur.fetchall()  # Récupérer tous les résultats sous forme de liste
        
        cur.execute("SELECT ident, nom_complet FROM chef_brigade")
        chef_brigades = cur.fetchall()
        return render_template('admin/dossier/liste_dossier.html',dossiers=dossiers,firstName=firstName,chef_brigades=chef_brigades)


@app.route('/valider_dossier_a/<int:dossier_id>', methods=['POST'])
def valider_dossier_a(dossier_id):
    if 'email_admin' not in session:
        return redirect(url_for('login'))

    try:
        # Obtenir les informations de connexion
        loggedIn, firstName = getLogin('email_admin', 'admin')
        print(f"Debug: loggedIn={loggedIn}, firstName={firstName}, dossier_id={dossier_id}")
        
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM dossier WHERE id = %s", (dossier_id,))
        dossier = cur.fetchone()
        print(f"Debug: dossier={dossier}")

        if not dossier:
            flash("Dossier introuvable.", "warning")
            return redirect(url_for('liste_dossier'))

        # Générer la date actuelle
        date_now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

        # Récupérer les informations du chef_brigade depuis le formulaire
        chef_brigade_id = request.form['chef_brigade_id']
        cur.execute("SELECT nom_complet FROM chef_brigade WHERE ident = %s", (chef_brigade_id,))
        chef_brigade = cur.fetchone()
        print(f"Debug: chef_brigade={chef_brigade}")

        if not chef_brigade:
            flash("Chef brigade introuvable.", "warning")
            return redirect(url_for('liste_dossier'))

        chef_brigade_name = chef_brigade[0]

        # Assigner le dossier à un chef_brigade et le mettre en cours
        cur.execute("""
            INSERT INTO gestion_chef_brigade 
            (nom_dossier, date_ajout, date_assignation, statut, n1_admin, n2_chef_brigade, id_chef_brigade)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (
            dossier[1], date_now, date_now, 'En cours', firstName, chef_brigade_name, chef_brigade_id
        ))

        # Insérer dans la table dossier_terminer
        cur.execute("""
            INSERT INTO dossier_terminer 
            (nom_dossier, date_ajout, date_assignation, date_terminer, statut, n1_admin)
            VALUES (%s, %s, %s, NOW(), %s, %s)
        """, (
            dossier[1], dossier[2], date_now, 'Terminé', firstName
        ))

        # Supprimer le dossier de la table dossier
        cur.execute("DELETE FROM dossier WHERE id = %s", (dossier_id,))
        
        mysql.connection.commit()
        flash("Le dossier a été assigné avec succès.", "success")
        return redirect(url_for('liste_dossier'))

    except Exception as e:
        mysql.connection.rollback()
        flash(f"Erreur lors de l'assignation du dossier : {str(e)}", "danger")
        return redirect(url_for('liste_dossier'))

    finally:
        if cur:
            cur.close()

############ chef brigade
@app.route("/inscription_chefbrigade",methods=['POST', 'GET'])
def inscription_chefbrigade():
    if 'email_admin' not in session:
        return redirect(url_for('login'))
    else:
        loggedIn, firstName = getLogin('email_admin', 'admin')
        if request.method == 'POST':
            name = request.form['name']
            prenom = request.form['prenom']
            nom_complet=name +' '+ prenom
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
                query = """INSERT INTO `chef_brigade` (nom_complet, email_chefbrigade, numero_telephone, password) 
                        VALUES (%s, %s, %s, %s)"""
                cursor.execute(query, (nom_complet, email, numero_telephone, hashed_password))
                mysql.connection.commit()
                return redirect('/')
            except Exception as e:
                return f"Erreur lors de l'inscription : {e}"
        return render_template('chef_brigade/connexion/cree_compte.html',firstName=firstName)


@app.route("/chef_brigade_tableau_de_bord")
def chef_brigade_tableau_de_bord():
    import datetime
    annee_actuelle = datetime.datetime.now().year
    loggedIn, firstName = getLogin('email_chefbrigade', 'chef_brigade')
    if 'email_chefbrigade' not in  session:
        return redirect(url_for('login'))
    else:
        cur = mysql.connection.cursor()
        cur.execute("SELECT COUNT(*) FROM gestion_chef_brigade WHERE id_chef_brigade = %s AND statut='En cours'", [loggedIn])
        en_cours = cur.fetchone()[0]
        # Requête avec filtre d'année dynamique
        requete = """
            SELECT COUNT(*) 
            FROM gestion_chef_brigade_terminer 
            WHERE id_chef_brigade = %s 
              AND statut = 'Terminé' 
              AND YEAR(date_ajout) = %s
        """

        # Exécution de la requête avec les paramètres
        cur.execute(requete, [loggedIn, annee_actuelle])

        # Récupérer le résultat
        termine = cur.fetchone()[0]
        cur.close()
        return render_template('chef_brigade/index.html', firstName=firstName,  en_cours=en_cours, termine=termine)
    

@app.route('/liste_gestion_chef_brigade')
def liste_gestion_chef_brigade():
    if 'email_chefbrigade' not in session:
        return redirect(url_for('login'))
    
    loggedIn, firstName = getLogin('email_chefbrigade', 'chef_brigade')
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM gestion_chef_brigade WHERE id_chef_brigade = %s AND statut='En cours' ORDER BY id DESC", (loggedIn,))
    dossiers = cur.fetchall()
    
    cur.execute("SELECT ident, nom_complet FROM brigade")
    brigades = cur.fetchall()
    cur.close()
    
    cur.close()
    return render_template('chef_brigade/dossier/liste_chef_brigade.html', dossiers=dossiers, loggedIn=loggedIn, firstName=firstName, brigades=brigades)



@app.route('/assigner_dossier_chefbrigade/<int:id_dossier>', methods=['POST'])
def assigner_dossier_chefbrigade(id_dossier):
    if 'email_chefbrigade' not in session:
        return redirect(url_for('login'))

    try:
        # Obtenir les informations de connexion
        loggedIn, firstName = getLogin('email_chefbrigade', 'chef_brigade')
        print(f"Debug: loggedIn={loggedIn}, firstName={firstName}, id_dossier={id_dossier}")
        
        cur = mysql.connection.cursor()
        cur.execute("""
            SELECT * FROM gestion_chef_brigade 
            WHERE id = %s
        """, (id_dossier,))
        dossier = cur.fetchone()
        print(f"Debug: dossier={dossier}")

        if not dossier:
            flash("Dossier introuvable ou non assigné.", "warning")
            return redirect(url_for('dossier_cours_chef_brigade'))

        # Générer la date actuelle
        date_now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

        # Assigner le dossier à un brigade
        brigade_id = request.form['brigade_id']  # ID du brigade sélectionné
        cur.execute("SELECT nom_complet FROM brigade WHERE ident = %s", (brigade_id,))
        brigade = cur.fetchone()
        print(f"Debug: brigade={brigade}")

        if not brigade:
            flash("Brigade introuvable.", "warning")
            return redirect(url_for('liste_gestion_chef_brigade'))

        brigade_name = brigade[0]

        cur.execute("""
            INSERT INTO gestion_brigade 
            (nom_dossier, date_ajout, date_assignation_termin_n2, date_assignation_n3, statut, n1_admin, n2_chef_brigade, id_chef_brigade, n3_brigade, id_brigade)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            dossier[1], dossier[2], date_now, date_now, 'En cours',
            dossier[5], firstName, loggedIn, brigade_name, brigade_id
        ))

        # Insérer dans la table gestion_chef_brigade_terminer
        cur.execute("""
            INSERT INTO gestion_chef_brigade_terminer 
            (nom_dossier, date_ajout, date_assignation, date_terminer, statut, n1_admin, n2_chef_brigade, id_chef_brigade)
            VALUES (%s, %s, %s, NOW(), %s, %s, %s, %s)
        """, (
            dossier[1], dossier[2], dossier[3], 'Terminé',
            dossier[5], firstName, loggedIn
        ))

        # Supprimer le dossier de la table gestion_chef_brigade
        cur.execute("DELETE FROM gestion_chef_brigade WHERE id = %s", (id_dossier,))
        
        mysql.connection.commit()
        flash("Le dossier a été assigné avec succès.", "success")
        return redirect(url_for('dossiers_valides'))

    except Exception as e:
        mysql.connection.rollback()
        flash(f"Erreur lors de l'assignation du dossier : {str(e)}", "danger")
        return redirect(url_for('liste_gestion_chef_brigade'))

    finally:
        if cur:
            cur.close()


@app.route('/dossiers_valides_teminer')
def dossiers_valides():
    # Vérifier si un chef de brigade est connecté
    if 'email_chefbrigade' not in session:
        return redirect(url_for('login'))
    else :
        loggedIn, firstName = getLogin('email_chefbrigade', 'chef_brigade')
        cur = mysql.connection.cursor()
        cur.execute("SELECT ident FROM chef_brigade WHERE email_chefbrigade = %s", [session['email_chefbrigade']])
        chef_brigade = cur.fetchone()
        cur.execute("""SELECT *FROM gestion_chef_brigade_terminer WHERE id_chef_brigade = %s AND statut = 'Terminé' ORDER BY id DESC limit 50""", [loggedIn])
        dossiers = cur.fetchall()
        # duree_dossier=calculer_difference(dossiers[4], dossiers[3])
        print(dossiers)
        cur.close()
        return render_template('chef_brigade/dossier/dossiers_terminer.html',
                               dossiers=dossiers, firstName=firstName, loggedIn=loggedIn
                               )




##### ------------ brigade
@app.route("/inscription_brigade",methods=['POST', 'GET'])
def inscription_brigade():
    if 'email_chefbrigade' not in session:
        return redirect(url_for('login'))
    else:
      loggedIn, firstName = getLogin('email_chefbrigade', 'chef_brigade')
      if request.method == 'POST':
        name = request.form['name']
        prenom = request.form['prenom']
        nom_complet = name + ' ' + prenom
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
            return redirect('/inscription_brigade')

        try:
            cursor = mysql.connection.cursor()
            query = """INSERT INTO `brigade` (nom_complet, email_brigade, numero_telephone, password) 
                       VALUES (%s, %s, %s, %s)"""
            cursor.execute(query, (nom_complet, email, numero_telephone, hashed_password))
            mysql.connection.commit()
            return redirect('/inscription_brigade')
        except Exception as e:
            return f"Erreur lors de l'inscription : {e}"
    return render_template('brigade/connexion/cree_compte.html', firstName=firstName)




@app.route("/brigade_tableau_de_bord")
def brigade_tableau_de_bord():
    import datetime
    annee_actuelle = datetime.datetime.now().year
    if 'email_brigade' not in  session:
        return redirect(url_for('login'))
    else:
        loggedIn, firstName = getLogin('email_brigade', 'brigade')
        cur = mysql.connection.cursor()
        cur.execute("SELECT COUNT(*) FROM gestion_brigade WHERE id_brigade = %s AND statut='En cours'", [loggedIn])
        en_cours = cur.fetchone()[0]
        cur.execute("SELECT COUNT(*) FROM gestion_brigade_terminer WHERE id_brigade = %s AND statut = 'Terminé'"
                    "AND YEAR(date_ajout) = %s",  [loggedIn, annee_actuelle])
        termine = cur.fetchone()[0]
        cur.close()
        return render_template('brigade/index.html', firstName=firstName,
                                en_cours=en_cours, termine=termine
                               )


@app.route('/liste_gestion_brigade')
def liste_gestion_brigade():
    if 'email_brigade' not in session:
        return redirect(url_for('login'))
    
    loggedIn, firstName = getLogin('email_brigade', 'brigade')
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM gestion_brigade WHERE id_brigade = %s AND statut='En cours' ORDER BY id DESC", (loggedIn,))
    dossiers = cur.fetchall()
    
    cur.close()
    return render_template('brigade/dossier/liste_brigade.html', dossiers=dossiers, loggedIn=loggedIn, firstName=firstName)


@app.route("/assigner_dossier_brigade/<int:id_dossier>", methods=['POST'])
def assigner_dossier_brigade(id_dossier):
    # Vérification de la session
    if 'email_brigade' not in session:
        return redirect(url_for('login'))

    loggedIn, firstName = getLogin('email_brigade', 'brigade')
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM gestion_brigade WHERE id = %s", (id_dossier,))
    dossier = cur.fetchone()
    # Mise à jour du dossier
    date_now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    cur.execute(""" UPDATE gestion_brigade 
                    SET date_assignation_n3 = %s, statut = %s, n3_brigade = %s, id_brigade = %s 
                    WHERE id = %s""", (date_now, 'En cours', firstName,loggedIn,id_dossier)
                )

    mysql.connection.commit()
    cur.close()
    flash("Le dossier a été pris en charge avec succès. Merci pour votre engagement.", "success")
    return redirect(url_for('dossier_cours_brigade'))


@app.route("/dossiers_cours_brigade", methods=['POST', 'GET'])
def dossier_cours_brigade():
    if 'email_brigade' not in session:
        flash("Vous devez être connecté pour accéder à cette page.", "danger")
        return redirect(url_for('login'))
    else:
        loggedIn, firstName = getLogin('email_brigade', 'brigade')
        print(loggedIn)
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM gestion_brigade WHERE statut='En cours' and  id_brigade = %s", (loggedIn,))
        dossiers = cur.fetchall()
        return render_template('brigade/dossier/liste_dossier_en_cours_brigade.html',
                               dossiers=dossiers, loggedIn=loggedIn, firstName=firstName)


@app.route('/terminer_dossier_brigade/<int:id_dossier>', methods=['POST'])
def terminer_dossier_brigade(id_dossier):
    if 'email_brigade' not in session:
        return redirect(url_for('login'))

    try:
        # Récupérer les informations de l'utilisateur connecté
        loggedIn, firstName = getLogin('email_brigade', 'brigade')

        with mysql.connection.cursor() as cur:
            # Vérifier si le dossier existe et est assigné à l'utilisateur
            cur.execute("""
                SELECT * FROM gestion_brigade 
                WHERE id = %s AND id_brigade = %s AND statut = 'En cours' """, (id_dossier, loggedIn))
            dossier = cur.fetchone()

            if not dossier:
                flash("Dossier introuvable ou non assigné.", "warning")
                return redirect(url_for('dossier_cours_brigade'))

            # Générer la date actuelle
            date_now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

            # Insérer dans la table gestion_securisation
            cur.execute("""
                INSERT INTO gestion_securisation 
                (nom_dossier, date_ajout, date_assignation_termin_n2, date_temine_n3, date_assignation_n4, statut, 
                n1_admin, n2_chef_brigade, id_chef_brigade, n3_brigade, id_brigade, n4_securisation, id_securisation)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                dossier[1], dossier[2], dossier[3], date_now, date_now, 'En attente',
                dossier[6], dossier[7], dossier[8], firstName, loggedIn, None, None
            ))

            # Insérer dans la table gestion_brigade_terminer
            cur.execute("""
                INSERT INTO gestion_brigade_terminer 
                (nom_dossier, date_ajout, date_assignation_termin_n2, date_assignation_n3, date_temine_n3, statut, 
                n1_admin, n2_chef_brigade, id_chef_brigade, n3_brigade, id_brigade)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                dossier[1], dossier[2], dossier[3], dossier[4], date_now, 'Terminé',
                dossier[6], dossier[7], dossier[8], firstName, loggedIn
            ))

            # Supprimer le dossier de la table gestion_brigade
            cur.execute("DELETE FROM gestion_brigade WHERE id = %s", (id_dossier,))

            # Confirmer les modifications
            mysql.connection.commit()

            flash("Le dossier a été marqué comme terminé avec succès.", "success")
            return redirect(url_for('dossiers_valides_brigade'))

    except Exception as e:
        flash(f"Une erreur est survenue : {str(e)}", "danger")
        mysql.connection.rollback()
        return redirect(url_for('dossiers_valides_brigade'))


@app.route('/dossiers_valides_brigade')
def dossiers_valides_brigade():
    # Vérifier si un chef de brigade est connecté
    if 'email_brigade' not in session:
        return redirect(url_for('login'))
    else :
        loggedIn, firstName = getLogin('email_brigade', 'brigade')
        cur = mysql.connection.cursor()
        cur.execute("SELECT ident FROM brigade WHERE email_brigade = %s", [session['email_brigade']])
        chef_brigade = cur.fetchone()
        cur.execute("""SELECT *FROM gestion_brigade_terminer WHERE id_brigade = %s AND statut = 'Terminé' ORDER BY id DESC limit 50""", [loggedIn])
        dossiers = cur.fetchall()
        # duree_dossier=calculer_difference(dossiers[4], dossiers[3])
        print(dossiers)
        cur.close()
        return render_template('brigade/dossier/dossiers_terminer_brigarde.html',
                               dossiers=dossiers, firstName=firstName, loggedIn=loggedIn
                               )




###################securisation
@app.route("/inscription_securisation",methods=['POST', 'GET'])
def inscription_securisation():
    if request.method == 'POST':
        name = request.form['name']
        prenom = request.form['prenom']
        nom_complet=name+" "+prenom
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
            query = """INSERT INTO `securisation` (nom_complet, email_securisation, numero_telephone, password) 
                       VALUES (%s, %s, %s, %s)"""
            cursor.execute(query, (nom_complet, email, numero_telephone, hashed_password))
            mysql.connection.commit()
            return redirect('/')
        except Exception as e:
            return f"Erreur lors de l'inscription : {e}"
    return render_template('securisation/connexion/cree_compte.html')

@app.route("/securisation_tableau_de_bord")
def securisation_tableau_de_bord():
    import datetime
    annee_actuelle = datetime.datetime.now().year
    if 'email_securisation' not in  session:
        return redirect(url_for('login'))
    else:
        loggedIn, firstName = getLogin('email_securisation', 'securisation')
        cur = mysql.connection.cursor()
        cur.execute("SELECT COUNT(*) FROM gestion_securisation WHERE statut = 'En attente'")
        en_attente = cur.fetchone()[0]
        cur.execute("SELECT COUNT(*) FROM gestion_securisation WHERE id_securisation = %s AND statut = 'En cours'", [loggedIn])
        en_cours = cur.fetchone()[0]
        cur.execute("SELECT COUNT(*) FROM gestion_securisation_terminer WHERE id_securisation = %s AND statut = 'Terminé'"
                    "AND YEAR(date_ajout) = %s", [loggedIn, annee_actuelle])
        termine = cur.fetchone()[0]
        cur.close()
        return render_template('securisation/index.html', firstName=firstName,
                                en_attente=en_attente, en_cours=en_cours, termine=termine
                               )


@app.route('/liste_gestion_securisation')
def liste_gestion_securisation():
    if 'email_securisation' in session:  # Vérifie si l'utilisateur est connecté
        # Récupération des informations de connexion
        loggedIn, firstName = getLogin('email_securisation', 'securisation')

        # Connexion à la base de données
        cur = mysql.connection.cursor(DictCursor)  # Active le mode dictionnaire pour des résultats clé-valeur
        # Exécution de la requête
        cur.execute("SELECT * FROM gestion_securisation WHERE statut = 'En attente'")
        dossiers = cur.fetchall()
        cur.close()  # Ferme le curseur après utilisation

        # Affichage pour le débogage
        print("Dossiers récupérés :", dossiers)

        # Rendu du template avec les données
        return render_template(
            'securisation/dossier/liste_securisation.html',
            dossiers=dossiers,
            loggedIn=loggedIn,
            firstName=firstName
        )
    else:
        # Redirection vers la page de connexion si l'utilisateur n'est pas connecté
        return redirect(url_for('login'))


@app.route("/assigner_dossier_securisation/<int:id_dossier>", methods=['POST'])
def assigner_dossier_securisation(id_dossier):
    # Vérification de la session
    if 'email_securisation' not in session:
        return redirect(url_for('login'))

    loggedIn, firstName = getLogin('email_securisation', 'securisation')
    cur = mysql.connection.cursor()
    # Mise à jour du dossier
    date_now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    cur.execute(""" UPDATE gestion_securisation 
                    SET date_assignation_n4 = %s, statut = %s, n4_securisation = %s, id_securisation = %s 
                    WHERE id = %s""", (date_now, 'En cours', firstName,loggedIn,id_dossier)
                )

    mysql.connection.commit()
    cur.close()
    flash("Le dossier a été pris en charge avec succès. Merci pour votre engagement.", "success")
    return redirect(url_for('dossier_cours_securisation'))


@app.route("/dossiers_cours_securisation", methods=['POST', 'GET'])
def dossier_cours_securisation():
    if 'email_securisation' not in session:
        flash("Vous devez être connecté pour accéder à cette page.", "danger")
        return redirect(url_for('login'))
    else:
        loggedIn, firstName = getLogin('email_securisation', 'securisation')
        # print(loggedIn)
        cur = mysql.connection.cursor(DictCursor)
        cur.execute("SELECT * FROM gestion_securisation WHERE statut='En cours' and  id_securisation = %s", (loggedIn,))
        dossiers = cur.fetchall()
        return render_template('securisation/dossier/liste_dossier_en_cours_securisation.html',
                               dossiers=dossiers, loggedIn=loggedIn, firstName=firstName)


@app.route('/terminer_dossier_securisation/<int:id_dossier>', methods=['POST'])
def terminer_dossier_securisation(id_dossier):
    if 'email_securisation' not in session:
        return redirect(url_for('login'))

    try:
        # Récupérer les informations de l'utilisateur connecté
        loggedIn, firstName = getLogin('email_securisation', 'securisation')

        with mysql.connection.cursor() as cur:  # Utilisation d'un curseur classique
            # Vérifier si le dossier existe et est assigné à l'utilisateur
            cur.execute("""
                SELECT * FROM gestion_securisation 
                WHERE id = %s AND id_securisation = %s AND statut = 'En cours'
            """, (id_dossier, loggedIn))
            columns = [desc[0] for desc in cur.description]
            result = cur.fetchone()
            dossier = dict(zip(columns, result)) if result else None

            if not dossier:
                flash("Dossier introuvable ou non assigné.", "warning")
                return redirect(url_for('dossier_cours_securisation'))

            # Générer la date actuelle
            date_now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

            # Insérer dans la table gestion_evaluation_cadastrale
            cur.execute("""
                INSERT INTO gestion_evaluation_cadastrale 
                (nom_dossier, date_ajout, date_assignation_termin_n2, date_temine_n3, date_assignation_n4, 
                 date_temine_n4, date_assignation_n5, statut, n1_admin, n2_chef_brigade, id_chef_brigade, 
                 n3_brigade, id_brigade, n4_securisation, id_securisation, n5_evaluation_cadastrale, id_evaluation_cadastrale)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                dossier["nom_dossier"], dossier["date_ajout"], dossier["date_assignation_termin_n2"],
                dossier["date_temine_n3"], dossier["date_assignation_n4"], date_now,
                date_now, 'En attente', dossier["n1_admin"], dossier["n2_chef_brigade"], dossier["id_chef_brigade"],
                dossier["n3_brigade"], dossier["id_brigade"], firstName, loggedIn,
                None, None
            ))

            # Insérer dans la table gestion_securisation_terminer
            cur.execute("""
                INSERT INTO gestion_securisation_terminer 
                (nom_dossier, date_ajout, date_assignation_termin_n2, date_temine_n3, date_assignation_n4, 
                 date_temine_n4, statut, n1_admin, n2_chef_brigade, id_chef_brigade, n3_brigade, id_brigade, 
                 n4_securisation, id_securisation, n5_evaluation, id_evaluation)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                dossier["nom_dossier"], dossier["date_ajout"], dossier["date_assignation_termin_n2"],
                dossier["date_temine_n3"], dossier["date_assignation_n4"], date_now, 'Terminé',
                dossier["n1_admin"], dossier["n2_chef_brigade"], dossier["id_chef_brigade"],
                dossier["n3_brigade"], dossier["id_brigade"], dossier["n4_securisation"], loggedIn,
                None, None
            ))
            cur.execute("DELETE FROM gestion_securisation WHERE id = %s", (id_dossier,))

            # Confirmer les modifications
            mysql.connection.commit()

            flash("Le dossier a été marqué comme terminé avec succès.", "success")
            return redirect(url_for('dossiers_valides_securisation'))

    except Exception as e:
        flash(f"Une erreur est survenue : {str(e)}", "danger")
        mysql.connection.rollback()
        return redirect(url_for('dossiers_valides_securisation'))


@app.route('/dossiers_valides_securisation')
def dossiers_valides_securisation():
    if 'email_securisation' not in session:
        return redirect(url_for('login'))
    else :
        loggedIn, firstName = getLogin('email_securisation', 'securisation')
        cur = mysql.connection.cursor(DictCursor)
        cur.execute("""SELECT *FROM gestion_securisation_terminer WHERE id_securisation = %s AND statut = 'Terminé'  ORDER BY id DESC limit 50""", [loggedIn])
        dossiers = cur.fetchall()
        # duree_dossier=calculer_difference(dossiers[4], dossiers[3])
        print(dossiers)
        cur.close()
        return render_template('securisation/dossier/dossiers_terminer_securisation.html',
                               dossiers=dossiers, firstName=firstName, loggedIn=loggedIn
                               )





###################evaluationcadastrale
@app.route("/inscription_evaluationcadastrale",methods=['POST', 'GET'])
def inscription_evaluationcadastrale():
    if request.method == 'POST':
        name = request.form['name']
        prenom = request.form['prenom']
        nom_complet = name + " " + prenom
        email = request.form['email']
        numero_telephone = request.form['numero_telephone']
        password = request.form['password']
        confirm_password = request.form['confirm_password']

        # Vérification de la confirmation de mot de passe
        if password != confirm_password:
            return "Les mots de passe ne correspondent pas. Veuillez réessayer."

        hashed_password = hashlib.md5(password.encode()).hexdigest()
        cursor = mysql.connection.cursor()
        
        cursor.execute("SELECT * FROM evaluation_cadastrale WHERE email_evaluation_cadastrale = %s", (email,))
        existing_user = cursor.fetchone()

        if existing_user:
            flash("Cet email est déjà utilisé. Veuillez en utiliser un autre.", "danger")
            return redirect('/inscription_admin')

        try:
            cursor = mysql.connection.cursor()
            query = """INSERT INTO `evaluation_cadastrale` (nom_complet, email_evaluation_cadastrale, numero_telephone, password) 
                       VALUES (%s, %s, %s, %s)"""
            cursor.execute(query, (nom_complet, email, numero_telephone, hashed_password))
            mysql.connection.commit()
            return redirect('/')
        except Exception as e:
            return f"Erreur lors de l'inscription : {e}"
    return render_template('evaluation_cadastrale/connexion/cree_compte.html')


@app.route("/evaluation_cadastrale_tableau_de_bord")
def evaluation_cadastrale_tableau_de_bord():
    import datetime
    annee_actuelle = datetime.datetime.now().year
    if 'email_evaluation_cadastrale' not in  session:
        return redirect(url_for('login'))
    else:
        loggedIn, firstName = getLogin('email_evaluation_cadastrale', 'evaluation_cadastrale')
        cur = mysql.connection.cursor()
        cur.execute("SELECT COUNT(*) FROM gestion_evaluation_cadastrale WHERE statut = 'En attente'")
        en_attente = cur.fetchone()[0]
        cur.execute("SELECT COUNT(*) FROM gestion_evaluation_cadastrale WHERE id_evaluation_cadastrale = %s AND statut = 'En cours'", [loggedIn])
        en_cours = cur.fetchone()[0]
        cur.execute("SELECT COUNT(*) FROM gestion_evaluation_cadastrale_terminer WHERE id_evaluation_cadastrale = %s AND statut = 'Terminé'"
                    "AND YEAR(date_ajout) = %s", [loggedIn, annee_actuelle])
        termine = cur.fetchone()[0]
        cur.close()
        return render_template('evaluation_cadastrale/index.html', firstName=firstName,
                                en_attente=en_attente, en_cours=en_cours, termine=termine
                               )


@app.route('/liste_gestion_evaluation_cadastrale')
def liste_gestion_evaluation_cadastrale():
    if 'email_evaluation_cadastrale' in session:  # Vérifie si l'utilisateur est connecté
        # Récupération des informations de connexion
        loggedIn, firstName = getLogin('email_evaluation_cadastrale', 'evaluation_cadastrale')

        # Connexion à la base de données
        cur = mysql.connection.cursor(DictCursor)  # Active le mode dictionnaire pour des résultats clé-valeur
        # Exécution de la requête
        cur.execute("SELECT * FROM gestion_evaluation_cadastrale WHERE statut = 'En attente'")
        dossiers = cur.fetchall()
        cur.close()  # Ferme le curseur après utilisation
        return render_template(
            'evaluation_cadastrale/dossier/liste_evaluation_cadastrale.html',
            dossiers=dossiers,
            loggedIn=loggedIn,
            firstName=firstName
        )
    else:
        return redirect(url_for('login'))


@app.route("/assigner_dossier_evaluation_cadastrale/<int:id_dossier>", methods=['POST'])
def assigner_dossier_evaluation_cadastrale(id_dossier):
    # Vérification de la session
    if 'email_evaluation_cadastrale' not in session:
        return redirect(url_for('login'))

    loggedIn, firstName = getLogin('email_evaluation_cadastrale', 'evaluation_cadastrale')
    cur = mysql.connection.cursor()
    # Mise à jour du dossier
    date_now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    cur.execute(""" UPDATE gestion_evaluation_cadastrale 
                    SET date_assignation_n5 = %s, statut = %s, n5_evaluation_cadastrale = %s, id_evaluation_cadastrale = %s 
                    WHERE id = %s""", (date_now, 'En cours', firstName,loggedIn,id_dossier)
                )

    mysql.connection.commit()
    cur.close()
    flash("Le dossier a été pris en charge avec succès. Merci pour votre engagement.", "success")
    return redirect(url_for('dossier_cours_evaluation_cadastrale'))


@app.route("/dossiers_cours_evaluation_cadastrale", methods=['POST', 'GET'])
def dossier_cours_evaluation_cadastrale():
    if 'email_evaluation_cadastrale' not in session:
        flash("Vous devez être connecté pour accéder à cette page.", "danger")
        return redirect(url_for('login'))
    else:
        loggedIn, firstName = getLogin('email_evaluation_cadastrale', 'evaluation_cadastrale')
        # print(loggedIn)
        cur = mysql.connection.cursor(DictCursor)
        cur.execute("SELECT * FROM gestion_evaluation_cadastrale WHERE statut='En cours' and  id_evaluation_cadastrale = %s", (loggedIn,))
        dossiers = cur.fetchall()
        return render_template('evaluation_cadastrale/dossier/liste_dossier_en_cours_evaluation_cadastrale.html',
                               dossiers=dossiers, loggedIn=loggedIn, firstName=firstName)


@app.route('/terminer_dossier_evaluation_cadastrale/<int:id_dossier>', methods=['POST'])
def terminer_dossier_evaluation_cadastrale(id_dossier):
    if 'email_evaluation_cadastrale' not in session:
        return redirect(url_for('login'))

    try:
        loggedIn, firstName = getLogin('email_evaluation_cadastrale', 'evaluation_cadastrale')

        if not loggedIn or not firstName:
            flash("Erreur: les informations utilisateur sont manquantes.", "danger")
            return redirect(url_for('dossiers_valides_evaluation_cadastrale'))

        with mysql.connection.cursor() as cur:
            cur.execute("""
                SELECT * FROM gestion_evaluation_cadastrale 
                WHERE id = %s AND id_evaluation_cadastrale = %s AND statut = 'En cours'
            """, (id_dossier, loggedIn))
            result = cur.fetchone()

            if not result:
                flash("Dossier introuvable ou non assigné.", "warning")
                return redirect(url_for('dossier_cours_evaluation_cadastrale'))

            columns = [desc[0] for desc in cur.description]
            dossier = dict(zip(columns, result))

            date_now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

            cur.execute("""
                INSERT INTO gestion_signature 
                (nom_dossier, date_ajout, date_assignation_termin_n2, date_temine_n3, date_assignation_n4, 
                 date_temine_n4, date_assignation_n5, date_temine_n5, date_assignation_n6, statut, n1_admin, 
                 n2_chef_brigade, id_chef_brigade, n3_brigade, id_brigade, n4_securisation, id_securisation, 
                 n5_evaluation_cadastrale, id_evaluation_cadastrale, n6_signature, id_signature)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                dossier["nom_dossier"], dossier["date_ajout"], dossier["date_assignation_termin_n2"],
                dossier["date_temine_n3"], dossier["date_assignation_n4"], dossier["date_temine_n4"],
                dossier["date_assignation_n5"], date_now, date_now, 'En attente',
                dossier["n1_admin"], dossier["n2_chef_brigade"], int(dossier["id_chef_brigade"]),
                dossier["n3_brigade"], int(dossier["id_brigade"]), dossier["n4_securisation"], int(dossier["id_securisation"]),
                dossier["n5_evaluation_cadastrale"], int(dossier["id_evaluation_cadastrale"]), 
                None, None
            ))

            cur.execute("""
                INSERT INTO gestion_evaluation_cadastrale_terminer 
                (nom_dossier, date_ajout, date_assignation_termin_n2, date_temine_n3, date_assignation_n4, 
                 date_temine_n4, date_assignation_n5, date_temine_n5, statut, n1_admin, n2_chef_brigade, id_chef_brigade, 
                 n3_brigade, id_brigade, n4_securisation, id_securisation, n5_evaluation_cadastrale, id_evaluation_cadastrale)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                dossier["nom_dossier"], dossier["date_ajout"], dossier["date_assignation_termin_n2"],
                dossier["date_temine_n3"], dossier["date_assignation_n4"], dossier["date_temine_n4"],
                dossier["date_assignation_n5"], date_now, 'Terminé', dossier["n1_admin"],
                dossier["n2_chef_brigade"], int(dossier["id_chef_brigade"]), dossier["n3_brigade"], int(dossier["id_brigade"]),
                dossier["n4_securisation"], int(dossier["id_securisation"]), dossier["n5_evaluation_cadastrale"], int(dossier["id_evaluation_cadastrale"])
            ))

            cur.execute("DELETE FROM gestion_evaluation_cadastrale WHERE id = %s", (id_dossier,))
            mysql.connection.commit()

            flash("Le dossier a été marqué comme terminé avec succès.", "success")
            return redirect(url_for('dossiers_valides_evaluation_cadastrale'))

    except mysql.connector.Error as e:
        flash("Une erreur interne est survenue. Veuillez réessayer.", "danger")
        return redirect(url_for('dossiers_valides_evaluation_cadastrale'))


@app.route('/dossiers_valides_evaluation_cadastrale')
def dossiers_valides_evaluation_cadastrale():
    if 'email_evaluation_cadastrale' not in session:
        return redirect(url_for('login'))
    else :
        loggedIn, firstName = getLogin('email_evaluation_cadastrale', 'evaluation_cadastrale')
        cur = mysql.connection.cursor(DictCursor)
        cur.execute("""
            SELECT * 
            FROM gestion_evaluation_cadastrale_terminer 
            WHERE id_evaluation_cadastrale = %s AND statut = 'Terminé' 
            ORDER BY id DESC 
            LIMIT 50 """, [loggedIn])
        dossiers = cur.fetchall()

        # duree_dossier=calculer_difference(dossiers[4], dossiers[3])
        print(dossiers)
        cur.close()
        return render_template('evaluation_cadastrale/dossier/dossiers_terminer_evaluation_cadastrale.html',
                               dossiers=dossiers, firstName=firstName, loggedIn=loggedIn
                               )









###################Signature
@app.route("/inscription_signature",methods=['POST', 'GET'])
def inscription_signature():
    if request.method == 'POST':
        name = request.form['name']
        prenom = request.form['prenom']
        nom_complet=name+" "+prenom
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
            query = """INSERT INTO `signature` (nom_complet, email_securisation, numero_telephone, password) 
                       VALUES (%s, %s, %s, %s)"""
            cursor.execute(query, (nom_complet, email, numero_telephone, hashed_password))
            mysql.connection.commit()
            return redirect('/')
        except Exception as e:
            return f"Erreur lors de l'inscription : {e}"
    return render_template('signature/connexion/cree_compte.html')

@app.route("/signature_fonciere_tableau_de_bord")
def signature_fonciere_tableau_de_bord():
    import datetime
    annee_actuelle = datetime.datetime.now().year
    if 'email_signature' not in session:
        return redirect(url_for('login'))

    # Récupérer l'état de connexion et le prénom
    loggedIn, firstName = getLogin('email_signature', 'signature')
    if not loggedIn:
        return redirect(url_for('login'))
    
    
    cur = mysql.connection.cursor()
    cur.execute("SELECT ident FROM signature WHERE email_signature = %s", [session['email_signature']])
    signature = cur.fetchone()

    id_signature = signature[0]

    # Requêtes SQL pour chaque statut
    cur.execute("SELECT COUNT(*) FROM gestion_signature WHERE statut = 'En attente'")
    en_attente = cur.fetchone()[0]

    cur.execute("SELECT COUNT(*) FROM gestion_signature WHERE id_signature = %s AND statut = 'En cours'", [id_signature])
    en_cours = cur.fetchone()[0]

    cur.execute("SELECT COUNT(*) FROM gestion_signature_terminer WHERE id_signature = %s AND statut = 'Terminé' AND YEAR(date_ajout) = %s", [id_signature,annee_actuelle])
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
    cur = mysql.connection.cursor(DictCursor) 
    cur.execute("""
        SELECT *
        FROM gestion_signature
        WHERE statut = 'En attente' ORDER BY id DESC LIMIT 50""")
    dossiers = cur.fetchall()
    cur.close()

    return render_template(
        "signature/dossier/liste_gestion_signature.html",
        dossiers=dossiers,
        loggedIn=loggedIn,
        firstName=firstName
    )

@app.route("/assigner_dossier_signature/<int:id_dossier>", methods=["POST"])
def assigner_dossier_signature(id_dossier):
    # Vérifier si l'utilisateur est connecté comme un membre de la sécurisation
    if 'email_signature' not in session:
        return redirect(url_for('login'))

    # Récupérer l'état de connexion et le prénom
    loggedIn, firstName = getLogin('email_signature', 'signature')
    if not loggedIn:
        return redirect(url_for('login'))


    # Récupérer l'ID de la personne qui assigne
    cur = mysql.connection.cursor()
    # Mise à jour du dossier
    date_now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    cur.execute("""UPDATE gestion_signature 
                    SET date_assignation_n6 = %s, statut = %s, n6_signature = %s, id_signature = %s 
                    WHERE id = %s """, (date_now, 'En cours', firstName,loggedIn,id_dossier))
    mysql.connection.commit()
    cur.close()

    flash("Dossier assigné avec succès.", "success")
    return redirect(url_for('liste_dossiers_assignes_signature'))

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
    cur = mysql.connection.cursor(DictCursor)
    cur.execute("SELECT * FROM gestion_signature WHERE statut='En cours' and  id_signature = %s ORDER BY id DESC LIMIT 50", (loggedIn,))
    dossiers = cur.fetchall()
    cur.close()
    return render_template( 
        "signature/dossier/dossiers_encours_signature.html",
        dossiers=dossiers,
        loggedIn=loggedIn,
        firstName=firstName
    )
    

@app.route('/valider_dossier_signature/<int:id_dossier>', methods=['POST'])
def valider_dossier_signature(id_dossier):
    # Vérifier si l'utilisateur est connecté et est un membre de la sécurisation
    if 'email_signature' not in session:
        return redirect(url_for('login'))

    try:
        loggedIn, firstName = getLogin('email_signature', 'signature')

        if not loggedIn or not firstName:
            flash("Erreur: les informations utilisateur sont manquantes.", "danger")
            return redirect(url_for('login'))

        with mysql.connection.cursor() as cur:
            # Vérifier si le dossier existe
            cur.execute("""
                SELECT * FROM gestion_signature 
                WHERE id = %s AND id_signature = %s AND statut = 'En cours'
            """, (id_dossier, loggedIn))
            result = cur.fetchone()

            if not result:
                flash("Dossier introuvable ou non assigné.", "warning")
                return redirect(url_for('dossiers_signature_valide'))

            columns = [desc[0] for desc in cur.description]
            dossier = dict(zip(columns, result))

            # Marquer le dossier comme terminé
            date_now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

            # Insérer dans gestion_conversation_fonciere
            cur.execute("""
                INSERT INTO gestion_conversation_fonciere 
                (nom_dossier, date_ajout, date_assignation_termin_n2, date_temine_n3, date_assignation_n4, 
                 date_temine_n4, date_assignation_n5, date_temine_n5, date_assignation_n6, date_temine_n6, date_assignation_n7, statut, n1_admin, 
                 n2_chef_brigade, id_chef_brigade, n3_brigade, id_brigade, n4_securisation, id_securisation, 
                 n5_evaluation_cadastrale, id_evaluation_cadastrale, n6_signature, id_signature, n7_conversation_fonciere, id_conversation_fonciere)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                dossier["nom_dossier"], dossier["date_ajout"], dossier["date_assignation_termin_n2"],
                dossier["date_temine_n3"], dossier["date_assignation_n4"], dossier["date_temine_n4"],
                dossier["date_assignation_n5"],dossier["date_temine_n5"],dossier["date_assignation_n6"], date_now, date_now, 'En attente',
                dossier["n1_admin"], dossier["n2_chef_brigade"], dossier["id_chef_brigade"],
                dossier["n3_brigade"], dossier["id_brigade"], dossier["n4_securisation"], dossier["id_securisation"],
                dossier["n5_evaluation_cadastrale"], dossier["id_evaluation_cadastrale"],
                dossier["n6_signature"], dossier["id_signature"], firstName, loggedIn
            ))

            # Insérer dans gestion_signature_terminer
            cur.execute("""
                INSERT INTO gestion_signature_terminer 
                (
                    nom_dossier, date_ajout, date_assignation_termin_n2, date_temine_n3, date_assignation_n4, 
                    date_temine_n4, date_assignation_n5, date_temine_n5, date_temine_n6, statut, n1_admin, 
                    n2_chef_brigade, id_chef_brigade, n3_brigade, id_brigade, n4_securisation, id_securisation, 
                    n5_evaluation_cadastrale, id_evaluation_cadastrale, n6_signature, id_signature
                )
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                dossier["nom_dossier"],
                dossier["date_ajout"],
                dossier["date_assignation_termin_n2"],
                dossier["date_temine_n3"],
                dossier["date_assignation_n4"],
                dossier["date_temine_n4"],
                dossier["date_assignation_n5"],
                dossier["date_temine_n5"],
                date_now,  # Utilisation de date_now pour date_temine_n6
                'Terminé',
                dossier["n1_admin"],
                dossier["n2_chef_brigade"],
                dossier["id_chef_brigade"],
                dossier["n3_brigade"],
                dossier["id_brigade"],
                dossier["n4_securisation"],
                dossier["id_securisation"],
                dossier["n5_evaluation_cadastrale"],
                dossier["id_evaluation_cadastrale"],
                dossier["n6_signature"],
                dossier["id_signature"]
            ))

            # Supprimer le dossier initial
            cur.execute("DELETE FROM gestion_signature WHERE id = %s", (id_dossier,))
            mysql.connection.commit()

            flash("Le dossier a été marqué comme terminé avec succès.", "success")
        return redirect(url_for('dossiers_signature_valide'))
    except Exception as e:
        return f"Erreur  : {e}"
        return redirect(url_for('dossiers_signature_valide'))



@app.route("/dossiers_signature_valide")
def dossiers_signature_valide():
    # Vérifier si l'utilisateur est connecté
    if 'email_signature' not in session:
        return redirect(url_for('login'))

    # Récupérer les informations de la brigade connectée
    loggedIn, firstName = getLogin('email_signature', 'signature')
    if not loggedIn:
        return redirect(url_for('login'))
    
    cur = mysql.connection.cursor(DictCursor)
    
    # Identifier le chef de brigade connecté
    cur.execute("SELECT ident FROM signature WHERE email_signature = %s", [session['email_signature']])
    signature = cur.fetchone()
    if not signature:
        flash("Erreur : signature introuvable.")
        return redirect(url_for('login'))

    cur.execute("""SELECT * FROM gestion_signature_terminer WHERE id_signature = %s AND statut = 'Terminé' ORDER BY id DESC LIMIT 50""", [loggedIn])
    dossiers = cur.fetchall()
    cur.close()
    
    return render_template(
        "signature/dossier/dossiers_terminer_signature.html",
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
        
        cursor.execute("SELECT * FROM conversation_fonciere WHERE email_conversation_fonciere = %s", (email,))
        existing_user = cursor.fetchone()

        if existing_user:
            flash("Cet email est déjà utilisé. Veuillez en utiliser un autre.", "danger")
            return redirect('/inscription_admin')

        try:
            cursor = mysql.connection.cursor()
            query = """INSERT INTO `conversation_fonciere` (name, prenom, email_conversation_fonciere, numero_telephone, password) 
                       VALUES (%s, %s, %s, %s, %s)"""
            cursor.execute(query, (name, prenom, email, numero_telephone, hashed_password))
            mysql.connection.commit()
            return redirect('/')
        except Exception as e:
            return f"Erreur lors de l'inscription : {e}"
    return render_template('conversation_fonciere/connexion/cree_compte.html')


@app.route("/conversation_fonciere_tableau_de_bord")
def conversation_fonciere_tableau_de_bord():
    import datetime
    annee_actuelle = datetime.datetime.now().year
    if 'email_conversation_fonciere' not in  session:
        return redirect(url_for('login'))
    else:
        loggedIn, firstName = getLogin('email_conversation_fonciere', 'conversation_fonciere')
        cur = mysql.connection.cursor()
        cur.execute("SELECT COUNT(*) FROM gestion_conversation_fonciere WHERE statut = 'En attente'")
        en_attente = cur.fetchone()[0]
        cur.execute("SELECT COUNT(*) FROM gestion_conversation_fonciere WHERE id_evaluation_cadastrale = %s AND statut = 'En cours'", [loggedIn])
        en_cours = cur.fetchone()[0]
        cur.execute("SELECT COUNT(*) FROM gestion_conversation_fonciere_terminer WHERE id_evaluation_cadastrale = %s AND statut = 'Terminé' "
                    "AND YEAR(date_ajout) = %s", [loggedIn, annee_actuelle])
        termine = cur.fetchone()[0]
        cur.close()
        return render_template('conversation_fonciere/index.html', firstName=firstName,
                                en_attente=en_attente, en_cours=en_cours, termine=termine
                               )

@app.route("/liste_gestion_fonciere")
def liste_gestion_fonciere():
    # Vérifier si l'utilisateur est connecté comme un membre de la sécurisation
    if 'email_conversation_fonciere' not in session:
        return redirect(url_for('login'))

    # Récupérer l'état de connexion et le prénom
    loggedIn, firstName = getLogin('email_conversation_fonciere', 'conversation_fonciere')
    if not loggedIn:
        return redirect(url_for('login'))

    # Récupérer la liste de tous les dossiers dans gestion_securisation
    cur = mysql.connection.cursor(DictCursor)
    cur.execute("""
        SELECT *
        FROM gestion_conversation_fonciere
        WHERE statut = 'En attente' ORDER BY id DESC LIMIT 50""")
    dossiers = cur.fetchall()
    cur.close()

    return render_template(
        "conversation_fonciere/dossier/liste_gestion_fonciere.html",
        dossiers=dossiers,
        loggedIn=loggedIn,
        firstName=firstName
    )

@app.route("/assigner_dossier_fonciere/<int:id_dossier>", methods=["POST"])
def assigner_dossier_fonciere(id_dossier):
    # Vérifier si l'utilisateur est connecté comme un membre de la sécurisation
    if 'email_conversation_fonciere' not in session:
        return redirect(url_for('login'))

    # Récupérer l'état de connexion et le prénom
    loggedIn, firstName = getLogin('email_conversation_fonciere', 'conversation_fonciere')
    if not loggedIn:
        return redirect(url_for('login'))


    # Récupérer l'ID de la personne qui assigne
    cur = mysql.connection.cursor()
    # Mise à jour du dossier
    date_now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    cur.execute("""UPDATE gestion_conversation_fonciere 
                    SET date_assignation_n7 = %s, statut = %s, n7_conversation_fonciere = %s, id_conversation_fonciere = %s 
                    WHERE id = %s""", (date_now, 'En cours', firstName,loggedIn,id_dossier))
    mysql.connection.commit()
    cur.close()

    flash("Dossier assigné avec succès.", "success")
    return redirect(url_for('liste_dossiers_assignes_fonciere'))

@app.route("/liste_dossiers_assignes_fonciere")
def liste_dossiers_assignes_fonciere():
    # Vérifier si l'utilisateur est connecté et est un membre de la sécurisation
    if 'email_conversation_fonciere' not in session:
        return redirect(url_for('login'))

    # Récupérer l'état de connexion et le prénom
    loggedIn, firstName = getLogin('email_conversation_fonciere', 'conversation_fonciere')
    if not loggedIn:
        return redirect(url_for('login'))
    # Récupérer les dossiers en cours pour cet utilisateur
    cur = mysql.connection.cursor(DictCursor)
    cur.execute("""
        SELECT *
        FROM gestion_conversation_fonciere
        WHERE statut = 'En cours' ORDER BY id DESC LIMIT 50 """)
    dossiers = cur.fetchall()
    cur.close()
    return render_template( 
        "conversation_fonciere/dossier/dossiers_encours_conversation_fonciere.html",
        dossiers=dossiers,
        loggedIn=loggedIn,
        firstName=firstName
    )

@app.route("/fin_dossier_fonciere/<int:id_dossier>", methods=["POST"])
def fin_dossier_fonciere(id_dossier):
    if 'email_conversation_fonciere' not in session:
        return redirect(url_for('login'))

    try:
        loggedIn, firstName = getLogin('email_conversation_fonciere', 'conversation_fonciere')

        if not loggedIn or not firstName:
            flash("Erreur: les informations utilisateur sont manquantes.", "danger")
            return redirect(url_for('login'))

        with mysql.connection.cursor() as cur:
            # Vérifier si le dossier existe
            cur.execute("""
                SELECT * FROM gestion_conversation_fonciere 
                WHERE id = %s AND id_conversation_fonciere = %s AND statut = 'En cours'
            """, (id_dossier, loggedIn))
            result = cur.fetchone()

            if not result:
                flash("Dossier introuvable ou non assigné.", "warning")
                return redirect(url_for('liste_dossiers_assignes_fonciere'))

            # Convertir le résultat en dictionnaire
            columns = [desc[0] for desc in cur.description]
            dossier = dict(zip(columns, result))

            # Vérifier et remplir les champs manquants avec des valeurs par défaut
            required_fields = [
                "nom_dossier", "date_ajout", "date_assignation_termin_n2", "date_temine_n3", 
                "date_assignation_n4", "date_temine_n4", "date_assignation_n5", "date_temine_n5", 
                "date_assignation_n6", "date_temine_n6", "date_assignation_n7", "n1_admin", 
                "n2_chef_brigade", "id_chef_brigade", "n3_brigade", "id_brigade", "n4_securisation", 
                "id_securisation", "n5_evaluation_cadastrale", "id_evaluation_cadastrale", 
                "n6_signature", "id_signature", "n7_conversation_fonciere", "id_conversation_fonciere"
            ]

            # Remplir les champs manquants
            for field in required_fields:
                if field not in dossier or dossier[field] is None:
                    dossier[field] = "" if isinstance(dossier.get(field, ""), str) else 0

            # Marquer le dossier comme terminé
            date_now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

            # Insérer dans gestion_conversation_fonciere_terminer
            cur.execute("""
                INSERT INTO gestion_conversation_fonciere_terminer 
                (nom_dossier, date_ajout, date_assignation_termin_n2, date_temine_n3, date_assignation_n4, 
                 date_temine_n4, date_assignation_n5, date_temine_n5, date_assignation_n6, date_temine_n6, 
                 date_assignation_n7, date_temine_n7, statut, n1_admin, n2_chef_brigade, id_chef_brigade, 
                 n3_brigade, id_brigade, n4_securisation, id_securisation, n5_evaluation_cadastrale, 
                 id_evaluation_cadastrale, n6_signature, id_signature, n7_conversation_fonciere, id_conversation_fonciere)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                dossier["nom_dossier"], dossier["date_ajout"], dossier["date_assignation_termin_n2"], 
                dossier["date_temine_n3"], dossier["date_assignation_n4"], dossier["date_temine_n4"], 
                dossier["date_assignation_n5"], dossier["date_temine_n5"], dossier["date_assignation_n6"], 
                dossier["date_temine_n6"], dossier["date_assignation_n7"], date_now, 'Terminé', 
                dossier["n1_admin"], dossier["n2_chef_brigade"], dossier["id_chef_brigade"], 
                dossier["n3_brigade"], dossier["id_brigade"], dossier["n4_securisation"], 
                dossier["id_securisation"], dossier["n5_evaluation_cadastrale"], dossier["id_evaluation_cadastrale"], 
                dossier["n6_signature"], dossier["id_signature"], dossier["n7_conversation_fonciere"], 
                dossier["id_conversation_fonciere"]
            ))

            # Supprimer le dossier initial
            cur.execute("DELETE FROM gestion_conversation_fonciere WHERE id = %s", (id_dossier,))
            mysql.connection.commit()

            flash("Le dossier a été marqué comme terminé avec succès.", "success")
        return redirect(url_for('dossiers_fonciere_valide'))

    except Exception as e:
        flash(f"Erreur : {e}", "danger")
        return redirect(url_for('liste_dossiers_assignes_fonciere'))

@app.route("/dossiers_fonciere_valide")
def dossiers_fonciere_valide():
    # Vérifier si l'utilisateur est connecté
    if 'email_conversation_fonciere' not in session:
        return redirect(url_for('login'))

    # Récupérer les informations de la brigade connectée
    loggedIn, firstName = getLogin('email_conversation_fonciere', 'conversation_fonciere')
    if not loggedIn:
        return redirect(url_for('login'))
    
    cur = mysql.connection.cursor(DictCursor)
    
    # Identifier le chef de brigade connecté
    cur.execute("SELECT ident FROM conversation_fonciere WHERE email_conversation_fonciere = %s", [session['email_conversation_fonciere']])
    conversation_fonciere = cur.fetchone()
    if not conversation_fonciere:
        flash("Erreur : conversation_fonciere introuvable.")
        return redirect(url_for('login'))
    
    
    cur.execute("""SELECT * FROM gestion_conversation_fonciere_terminer WHERE id_conversation_fonciere = %s AND statut = 'Terminé' ORDER BY id DESC LIMIT 50""", [loggedIn])
    dossiers = cur.fetchall()
    cur.close()
    
    return render_template(
        "conversation_fonciere/dossier/dossiers_terminer_conversation_fonciere.html",
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
            return redirect(url_for('chef_brigade_tableau_de_bord'))

        elif is_valid(email, "email_brigade", password, "brigade"):
            session['email_brigade'] = email
            return redirect(url_for('brigade_tableau_de_bord'))

        elif is_valid(email, "email_securisation", password, "securisation"):
            session['email_securisation'] = email
            return redirect(url_for('securisation_tableau_de_bord'))

        elif is_valid(email, "email_conversation_fonciere", password, "conversation_fonciere"):
            session['email_conversation_fonciere'] = email
            return redirect(url_for('conversation_fonciere_tableau_de_bord'))
        elif is_valid(email, "email_evaluation_cadastrale", password, "evaluation_cadastrale"):
            session['email_evaluation_cadastrale'] = email
            return redirect(url_for('evaluation_cadastrale_tableau_de_bord'))
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
            "evaluation_cadastrale": "email_evaluation_cadastrale",
            "signature": "email_signature",
            "conversation_fonciere": "email_conversation_fonciere"
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

            flash("Un e-mail contenant un lien de réinitialisation a été envoyé à votre adresse.", "success")
            return redirect('/')

        flash("Nous n'avons pas trouvé cette adresse e-mail dans notre système. Veuillez vérifier et réessayer.", 'danger')
        return redirect('/forgot_password')

    return render_template('mot_de passe_oublier/mot_de_passe_oublier.html')


@app.route('/reset_password/<table>/<token>', methods=['GET', 'POST'])
def reset_password(table, token):
    # Dictionnaire des colonnes d'email pour chaque table
    email_columns = {
        "chef_brigade": "email_chefbrigade",
        "brigade": "email_brigade",
        "securisation": "email_securisation",
        "evaluation_cadastrale": "email_evaluation_cadastrale",
        "signature": "email_signature",
        "conversation_fonciere": "email_conversation_fonciere"
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