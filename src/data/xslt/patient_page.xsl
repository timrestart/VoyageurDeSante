<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:med="http://www.ujf-grenoble.fr/l3miage/medical">

	<xsl:output method="html"/>

	<xsl:variable name="actes" select="document('actes.xml', /)/ngap"/>

	<!--
		* Afficher le titre de la page
		* Afficher "Bonjour <prénom du patient>
		* Créer une liste contenant : nom, prénom, sexe, date de naissance,
		numéro sécu, adresse du patient
		* Créer un tableau des visite du patient trié par @date contenant:
			* la date dela visite
			* la liste oins reçu par le patient
			* le nom et prénom de l'intervenant
	-->
	<xsl:template match="/">
		<html>
			<head>
				<title>Patient</title>
				<link rel="stylesheet" type="text/css" href="../css/cabinet.css"/>
			</head>
			<body>
				<h1>PATIENT</h1>
				<div class="greeting">
					<p>
						Bonjour <xsl:value-of select="patient/prénom"/>
					</p>
				</div>
				<ul>
					<li>
						Nom :
						<xsl:value-of select="patient/nom"/> 
					</li>
					<li>
						Prénom :
						<xsl:value-of select="patient/prénom"/> 
					</li>
					<li>
						Sexe :
						<xsl:value-of select="patient/sexe"/> 
					</li>
					<li>
						Naissance :
						<xsl:value-of select="patient/naissance"/>
					</li>
					<li>
						Numéro Secu :
						<xsl:value-of select="patient/numéroSS"/>
					</li>
					<li>
						Adresse : 
						<xsl:if test="patient/adresse/étage">
							Etage <xsl:value-of select="patient/adresse/étage"/>, 
						</xsl:if>
						<xsl:if test="patient/adresse/numéro">
							numéro <xsl:value-of select="patient/adresse/numéro"/>, 
						</xsl:if>
						<xsl:value-of select="patient/adresse/rue"/>, 
						<xsl:value-of select="patient/adresse/ville"/>, 
						<xsl:value-of select="patient/adresse/codePostal"/>
					</li>
				</ul>
				<br/>
				<p>
					Vous avez <xsl:value-of select="count(patient/visite)"/> visite(s)
					<br/>
					<br/>
				</p>
				<table>
					<tr>
						<th>DATE</th>
						<th>SOINS</th>
						<th>INTERVENANT (nom, prénom)</th>
					</tr>
					<xsl:apply-templates select="patient/visite">
						<xsl:sort select="@date"/>
					</xsl:apply-templates>
				</table>
			</body>
		</html>
	</xsl:template>

	<!--
		Pour chaque visite du patient :
		créer une ligne du tableau contenant :
		* la date de la visite
		* une liste des actes 
	-->
	<xsl:template match="patient/visite">
		<tr>
			<td>
				<xsl:value-of select="@date"/>
			</td>
			<td>
				<ul>
					<xsl:apply-templates select="acte"/>
				</ul>
			</td>
			<td>
				<xsl:value-of select="intervenant/nom"/>, 
				<xsl:value-of select="intervenant/prénom"/>
			</td>
		</tr>
	</xsl:template>

	<!--
		Pour chaque acte de la visite courant :
		créer un item de liste contenant :
		* le nom de l'acte
	-->
	<xsl:template match="acte">
		<li>
			<xsl:value-of select="."/>
		</li>
	</xsl:template>
</xsl:stylesheet>

