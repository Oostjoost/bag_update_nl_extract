# bag_update_nl_extract
Backup, download and restore BAG from NL Extract
Met dit batch bestand wordt automatisch de BAG gedownload vanaf NL Extract en gerestored in een Postgresql Database. 

Belangrijk, pas eerst de instellingen aan in het batch bestand (zie opmerkingen in de code):
•	Database connectie parameters
•	Parameters die verwijzen naar het restore, backup en psql commando
•	Locatie t.b.v. de download

Dit script download de complete BAG, maakt een backup van de bestaande en restored de nieuwe download. 
Ik heb dit batch-bestand in een schedule draaien op elke 25e van de maand. 
NL Extract plaatst meestal rond de 20e de nieuwe maandelijkse versie online.

Mocht je hier vragen over hebben dan hoor ik het graag.
