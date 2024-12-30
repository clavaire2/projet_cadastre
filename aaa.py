@app.route("/conversation_fonciere_tableau_de_bord")
def conversation_fonciere_tableau_de_bord():
    if 'email_evaluation_cadastrale' not in  session:
        return redirect(url_for('login'))
    else:
        loggedIn, firstName = getLogin('email_evaluation_cadastrale', 'conversation_fonciere')
        cur = mysql.connection.cursor()
        cur.execute("SELECT COUNT(*) FROM gestion_evaluation_cadastrale WHERE statut = 'En attente'")
        en_attente = cur.fetchone()[0]
        cur.execute("SELECT COUNT(*) FROM gestion_evaluation_cadastrale WHERE id_evaluation_cadastrale = %s AND statut = 'En cours'", [loggedIn])
        en_cours = cur.fetchone()[0]
        cur.execute("SELECT COUNT(*) FROM gestion_evaluation_cadastrale_terminer WHERE id_evaluation_cadastrale = %s AND statut = 'Terminé'", [loggedIn])
        termine = cur.fetchone()[0]
        cur.close()
        return render_template('conversation_fonciere/index.html', firstName=firstName,
                                en_attente=en_attente, en_cours=en_cours, termine=termine
                               )


@app.route('/liste_gestion_evaluation_cadastrale')
def liste_gestion_evaluation_cadastrale():
    if 'email_evaluation_cadastrale' in session:  # Vérifie si l'utilisateur est connecté
        # Récupération des informations de connexion
        loggedIn, firstName = getLogin('email_evaluation_cadastrale', 'conversation_fonciere')

        # Connexion à la base de données
        cur = mysql.connection.cursor(DictCursor)  # Active le mode dictionnaire pour des résultats clé-valeur
        # Exécution de la requête
        cur.execute("SELECT * FROM gestion_evaluation_cadastrale WHERE statut = 'En attente'")
        dossiers = cur.fetchall()
        cur.close()  # Ferme le curseur après utilisation

        # Affichage pour le débogage
        print("Dossiers récupérés :", dossiers)

        # Rendu du template avec les données
        return render_template(
            'conversation_fonciere/dossier/liste_evaluation_cadastrale.html',
            dossiers=dossiers,
            loggedIn=loggedIn,
            firstName=firstName
        )
    else:
        # Redirection vers la page de connexion si l'utilisateur n'est pas connecté
        return redirect(url_for('login'))


@app.route("/assigner_dossier_evaluation_cadastrale/<int:id_dossier>", methods=['POST'])
def assigner_dossier_evaluation_cadastrale(id_dossier):
    # Vérification de la session
    if 'email_evaluation_cadastrale' not in session:
        return redirect(url_for('login'))

    loggedIn, firstName = getLogin('email_evaluation_cadastrale', 'conversation_fonciere')
    cur = mysql.connection.cursor()
    # Mise à jour du dossier
    date_now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    cur.execute(""" UPDATE gestion_evaluation_cadastrale 
                    SET date_assignation_n4 = %s, statut = %s, n4_evaluation_cadastrale = %s, id_evaluation_cadastrale = %s 
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
        loggedIn, firstName = getLogin('email_evaluation_cadastrale', 'conversation_fonciere')
        # print(loggedIn)
        cur = mysql.connection.cursor(DictCursor)
        cur.execute("SELECT * FROM gestion_evaluation_cadastrale WHERE statut='En cours' and  id_evaluation_cadastrale = %s", (loggedIn,))
        dossiers = cur.fetchall()
        return render_template('conversation_fonciere/dossier/liste_dossier_en_cours_evaluation_cadastrale.html',
                               dossiers=dossiers, loggedIn=loggedIn, firstName=firstName)


@app.route('/terminer_dossier_evaluation_cadastrale/<int:id_dossier>', methods=['POST'])
def terminer_dossier_evaluation_cadastrale(id_dossier):
    if 'email_evaluation_cadastrale' not in session:
        return redirect(url_for('login'))

    try:
        # Récupérer les informations de l'utilisateur connecté
        loggedIn, firstName = getLogin('email_evaluation_cadastrale', 'conversation_fonciere')

        with mysql.connection.cursor() as cur:  # Utilisation d'un curseur classique
            # Vérifier si le dossier existe et est assigné à l'utilisateur
            cur.execute("""
                SELECT * FROM gestion_evaluation_cadastrale 
                WHERE id = %s AND id_evaluation_cadastrale = %s AND statut = 'En cours'
            """, (id_dossier, loggedIn))
            columns = [desc[0] for desc in cur.description]
            result = cur.fetchone()
            dossier = dict(zip(columns, result)) if result else None

            if not dossier:
                flash("Dossier introuvable ou non assigné.", "warning")
                return redirect(url_for('dossier_cours_evaluation_cadastrale'))

            # Générer la date actuelle
            date_now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

            # Insérer dans la table gestion_evaluation_cadastrale
            cur.execute("""
                INSERT INTO gestion_evaluation_cadastrale 
                (nom_dossier, date_ajout, date_assignation_termin_n2, date_temine_n3, date_assignation_n4, 
                 date_temine_n4, date_assignation_n5, statut, n1_admin, n2_chef_brigade, id_chef_brigade, 
                 n3_brigade, id_brigade, n4_evaluation_cadastrale, id_evaluation_cadastrale, n5_evaluation, id_evaluation)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                dossier["nom_dossier"], dossier["date_ajout"], dossier["date_assignation_termin_n2"],
                dossier["date_temine_n3"], dossier["date_assignation_n4"], date_now,
                date_now, 'En attente', dossier["n1_admin"], dossier["n2_chef_brigade"], dossier["id_chef_brigade"],
                dossier["n3_brigade"], dossier["id_brigade"], dossier["n4_evaluation_cadastrale"], loggedIn,
                None, None
            ))

            # Insérer dans la table gestion_evaluation_cadastrale_terminer
            cur.execute("""
                INSERT INTO gestion_evaluation_cadastrale_terminer 
                (nom_dossier, date_ajout, date_assignation_termin_n2, date_temine_n3, date_assignation_n4, 
                 date_temine_n4, statut, n1_admin, n2_chef_brigade, id_chef_brigade, n3_brigade, id_brigade, 
                 n4_evaluation_cadastrale, id_evaluation_cadastrale, n5_evaluation, id_evaluation)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                dossier["nom_dossier"], dossier["date_ajout"], dossier["date_assignation_termin_n2"],
                dossier["date_temine_n3"], dossier["date_assignation_n4"], date_now, 'Terminé',
                dossier["n1_admin"], dossier["n2_chef_brigade"], dossier["id_chef_brigade"],
                dossier["n3_brigade"], dossier["id_brigade"], dossier["n4_evaluation_cadastrale"], loggedIn,
                None, None
            ))

            # Supprimer le dossier de la table gestion_evaluation_cadastrale
            cur.execute("DELETE FROM gestion_evaluation_cadastrale WHERE id = %s", (id_dossier,))

            # Confirmer les modifications
            mysql.connection.commit()

            flash("Le dossier a été marqué comme terminé avec succès.", "success")
            return redirect(url_for('dossiers_valides_evaluation_cadastrale'))

    except Exception as e:
        flash(f"Une erreur est survenue : {str(e)}", "danger")
        mysql.connection.rollback()
        return redirect(url_for('dossiers_valides_evaluation_cadastrale'))


@app.route('/dossiers_valides_evaluation_cadastrale')
def dossiers_valides_evaluation_cadastrale():
    if 'email_evaluation_cadastrale' not in session:
        return redirect(url_for('login'))
    else :
        loggedIn, firstName = getLogin('email_evaluation_cadastrale', 'evaluation_cadastrale')
        cur = mysql.connection.cursor(DictCursor)
        cur.execute("""SELECT *FROM gestion_evaluation_cadastrale_terminer WHERE id_evaluation_cadastrale = %s AND statut = 'Terminé'""", [loggedIn])
        dossiers = cur.fetchall()
        # duree_dossier=calculer_difference(dossiers[4], dossiers[3])
        print(dossiers)
        cur.close()
        return render_template('conversation_fonciere/dossier/dossiers_terminer_evaluation_cadastrale.html',
                               dossiers=dossiers, firstName=firstName, loggedIn=loggedIn
                               )

