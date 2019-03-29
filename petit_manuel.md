# Petit manuel

## Dossiers

scenarios: Le dossiers "scenarios" contient les datasets utilisés dans les différents scénarios ainsi que le fichier JMeter permettant de rouler ces scénarios.

results: Le dossier "results" contient les résultats d'exécution des différents scénarios.

## Dépendances

1. Installez [docker](https://www.docker.com/) et [docker-compose](https://docs.docker.com/compose/).
2. Intallez `Maven`
2. Clonez ce répertoire: `git clone git@github.com:Aboisier/jguwekarest.git`

# Exécuter avec docker-compose
1. Depuis le dossier contenant le _repository_, exécutez `docker-compose up`

## Pour scaler
1. Exécutez `docker-compose up scale jguweka=n`, `n` étant le nombre d'instances que vous désirez

# Builder et exécuter le tout manuellement
## _Builder_ l'image docker
1. Nettoyer le package en exécutant

```sh
mvn clean package
```

2. _Builder_ l'image en exécutant 

```sh
docker build -t <votre_nom_dutilisateur_docker_hub>/jguweka:OAS3 .
```

## Démarrer l'image docker
1. Démarrez une instance de mongo: 
```
docker pull mongo; docker run --name mongodb -d mongo
```
2. Démarrez l'image:  
```sh
docker run -p 8080:8080 -p 8849:8849 --link mongodb:mongodb <votre_nom_dutilisateur_docker_hub>/jguweka:OAS3
```

## Pour démarrer l'agent JProfiler

1. Connectez-vous à votre _container_

```sh
docker exec -it [nom_de_votre_conteneur] bash
```

2. Exécutez la commande suivante

```sh
/usr/local/jprofiler9/bin/jpenable -g -p 8849
```

## Exécuter les scénarios

Les différents scénarios ont été créés à l'aide de JMeter et sont disponibles dans le fichier Scenarios.jmx. 

1. Lancez JMeter.

2. Ouvrez le fichier Scenarios.jmx (dans le dossier "scenarios").

3. Activez le scénario désiré en cliquant sur "Enable" dans le menu de contexte du scenario (clic droit sur le scenario voulu).

4. Assurez-vous que les autres scénarios sont désactivés en cliquant sur "Disable" dans leurs menus de contexte respectifs.

5. Lancez le scénario en cliquant sur le bouton "Start" (bouton Play vert).