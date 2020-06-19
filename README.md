# Un station de développement portable #

## Objectif ##

L'objectif de ce projet est de proposer les outils de base pour l'apprentissage de l'informatique en licence et master sous forme facilement utilisable et reproductible en TP, sur une machine personnelle quel que soit l'OS et à distance via un navigateur web.

Deux modes d'utilisation sont attendus :

* En local sur une machine de TP ou personnelle
  * A travers une interface web (terminal, IDE de développement, ...)
  * Par export graphique pour les applications lourdes (Actuelle simple uniquement sous linux et macOS).
* A distance via la même interface web qu'en local à partir d'un simple navigateur web depuis un PC ou une tablette.

## Quickstart ##

Démarrer un conteneur docker qui contient les outils de développement de base (python3, C, C++, java) et un IDE web.
Le sous-répertoire `workspace` du répertoire courant de l'hôte est accessible depuis le conteneur.
Le sous-répertoire `dockerdevstation` du répertoire courant de l'hôte rend persistante la configuration de l'éditeur.
Il est possible de faire de même pour les caches des applications (artefacts Java, python, ...).

```bash
docker run  --name=devstation --rm \
  -e PUID=$UID \
  -e PGID=$GID \
  -e SUDO_PASSWORD=abc \
  -e SHELL=bash \
  -e TZ=Europe/Paris \
  -p 8443:8443 \
  -v $PWD/config:/config \
  -v $PWD/workspace:/config/workspace \
  brunoe/dockerdevstation
```

## En ligne de commande ##

Ouvrir un shell en root avec les même outils.

```bash
docker run --rm -it \
  --entrypoint /bin/bash \
  brunoe/dockerdevstation
```

## Application graphique #

Lancer un éditeur graphique quelconque (ici intellij idea pour java, python, PHP, ...) depuis le conteneur.
Attention, cela ne marche simplement que sous linux.

```bash
xhost + local:

docker run --rm -it \
  -e DISPLAY=${DISPLAY} \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  --entrypoint /opt/idea/bin/idea.sh \
  brunoe/dockerdevstation
```

## Accès à distance ##

Pour tester purement en ligne avec un simple navigateur web :

  1. aller sur <https://labs.play-with-docker.com> puis `login, Docker` puis `start`
  2. Cliquer sur "add new instance"  
  3. exécuter la première commande docker de cette page
  4. attendre que "HTTP server listening on..." apparaissent
  5. cliquer sur le bouton "open port" en indiquant 8443

## Choix techniques ##

Actuellement ce projet n'est qu'une preuve de concept.
De nombreuses questions restent ouvertes (sécurisation, passage à l'échelle, ...).

Il s'appuie sur les outils suivants :

* Docker comme technologie de conteneur.
* IDE Web vscode ou code9

## Evolutions ##

* L'intégration d'autres outils (jupyter, ...) est générame simple (script d'installation et de configuration).
* Il est simple d'ajouter des containers en parallèle pour les autres services accessible via le réseau (serveurs de gestion base de données, logiciels de calcul, ...).
* L'utilisation des GPU de l'hôte pour le calcul est possible mais délicat en cas de partage de l'hôte.
* Produire un ensemble hiérachique d'images pour alléger l'usage.

## Points bloquants ##

* L'accélération ou les applications graphiques.
