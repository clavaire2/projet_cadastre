@app.route("/rechercher", methods=["GET", "POST"])
def rechercher_dossier():
    if request.method == "POST":
        nom_dossier = request.form.get("nom_dossier")
        if not nom_dossier:
            return render_template(
                "resultat.html",
                error="Veuillez saisir un nom de dossier.",
                dossiers=None
            )

        # Liste des tables à vérifier
        tables = [
            "gestion_chef_brigade", "gestion_brigade", "gestion_securisation",
            "gestion_evaluation_cadastrale", "gestion_signature", "gestion_conversation_fonciere",
            "gestion_chef_brigade_terminer", "gestion_brigade_terminer",
            "gestion_securisation_terminer", "gestion_evaluation_cadastrale_terminer",
            "gestion_signature_terminer", "gestion_conversation_fonciere_terminer"
        ]

        # Préparer la liste des dossiers trouvés
        dossiers = []

        # Connexion à la base de données
        cur = mysql.connection.cursor()
        try:
            for table in tables:
                query = f"""
                SELECT 
                    nom_dossier, date_ajout, date_assignation_terminer_n3,
                    nom_n1, nom_n2, nom_n3, date_assignation_n4, votre_nom, statut
                FROM {table}
                WHERE nom_dossier LIKE %s
                """
                cur.execute(query, (f"%{nom_dossier}%",))
                results = cur.fetchall()
                for result in results:
                    dossiers.append({
                        "table": table,
                        "nom_dossier": result[0],
                        "date_ajout": result[1],
                        "date_assignation_n3": result[2],
                        "nom_n1": result[3],
                        "nom_n2": result[4],
                        "nom_n3": result[5],
                        "date_assignation_n4": result[6],
                        "votre_nom": result[7],
                        "statut": result[8],
                    })

            return render_template(
                "resultat.html",
                dossiers=dossiers,
                nom_dossier=nom_dossier,
                error=None
            )
        except Exception as e:
            return render_template(
                "resultat.html",
                error=f"Erreur : {str(e)}",
                dossiers=None
            )
        finally:
            cur.close()
    return render_template("resultat.html", dossiers=None, error=None)
