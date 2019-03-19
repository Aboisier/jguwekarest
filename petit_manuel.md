# Petit manuel

## Dépendances

1. Installez [docker](https://www.docker.com/) et [docker-compose](https://docs.docker.com/compose/).
2. Intallez `Maven`
2. Clonez ce répertoire: `git clone git@github.com:Aboisier/jguwekarest.git`


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

2. Naviguez jusqu'au dossier où se trouve JProfiler et exécutez `jpenable`

```sh
cd /usr/local/jprofiler9/
bin/jpenable
```

3. `jpenable` vous demandera d'entrer des informations. Entres `1` puis `8849`.
