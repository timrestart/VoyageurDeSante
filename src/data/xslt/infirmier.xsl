<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:med="http://www.ujf-grenoble.fr/l3miage/medical">

	<xsl:output method="html"/>

	<xsl:param name="destinedId" select="001"/>
	<xsl:variable name="actes" select="document('actes.xml', /)/ngap"/>

	<!--
		* Selectionner l'ensemble des elements med:visites dont l'attribut @intervenant
		correspond à la valeur de $destinedId
		* Afficher un titre pour la page html
		* Afficher "Bonjour <prénom de l'infirmier>
		* Afficher le nom, prénom et ID de l'infirmier
		* Appliquer une template pour afficher un tableau des med:visite trié par @date
	-->
	<xsl:template match="/">
		<xsl:variable name="visiteDuJour" select="//med:visite[@intervenant=$destinedId]"/>
		<html>
			<head>
				<title>Infirmier</title>
				<link rel="stylesheet" type="text/css" href="../css/cabinet.css"/>
				<script type="text/javascript">
					<![CDATA[
						function openFacture(prenom, nom, actes) {
							   var width  = 500;
							   var height = 300;
							   if(window.innerWidth) {
								   var left = (window.innerWidth-width)/2;
								   var top = (window.innerHeight-height)/2;
							   }
							   else {
								   var left = (document.body.clientWidth-width)/2;
								   var top = (document.body.clientHeight-height)/2;
							   }
							   var factureWindow = window.open('','facture','menubar=yes, scrollbars=yes, top='+top+', left='+left+', width='+width+', height='+height+'');
							   factureText = "Facture pour : " + prenom + " " + nom;
							   factureWindow.document.write(factureText);
							}
					]]>
				</script>
			</head>
			<body>
				<h1>INFIRMIER</h1>
				<div class="greeting">
					<p>
						Bonjour <xsl:value-of select="//med:infirmier[@id=$destinedId]/med:prénom"/>
					</p>
				</div>
				<ul>
					<li>
						Nom :
						<xsl:value-of select="//med:infirmier[@id=$destinedId]/med:nom"/> 
					</li>
					<li>
						Prénom :
						<xsl:value-of select="//med:infirmier[@id=$destinedId]/med:prénom"/> 
					</li>
					<li>
						ID :
						<xsl:value-of select="//med:infirmier[@id=$destinedId]/@id"/> 
					</li>
				</ul>
				<br/>
				<p>
					Vous avez <xsl:value-of select="count($visiteDuJour)"/> patient(s)
					<br/>
					<br/>
				</p>
				<table>
					<tr>
						<th>DATE</th>
						<th>PATIENT (nom, prénom)</th>
						<th>ADRESSE</th>
						<th>SOINS</th>
						<th>FACTURE</th>
					</tr>
					<xsl:apply-templates select="//med:patient[med:visite/@intervenant=$destinedId]">
						<xsl:sort select="med:visite/@date"/>
					</xsl:apply-templates>
				</table>
			</body>
		</html>
	</xsl:template>

	<!--
		Pour chaque med:patient que l'intervenant $destinedId visite :
		créer un ligne du tableau contenant :
		* la date de la visite
		* le nom et prénom du patient
		* l'adresse du patient
		* une liste des actes que l'intervenant effectue sur ce med:patient
		* un bouton affichant la facture de la visite
	-->
	<xsl:template match="//med:patient[med:visite/@intervenant=$destinedId]">

		<tr>
			<td>
				<xsl:value-of select="med:visite/@date"/>
			</td>
			<td>
				<p>
					<xsl:value-of select="med:nom"/>, 
					<xsl:value-of select="med:prénom"/>
				</p>
			</td>

			<td>
				<xsl:if test="med:adresse/med:étage">
					Etage <xsl:value-of select="med:adresse/med:étage"/>, 
				</xsl:if>
				<xsl:if test="med:adresse/med:numéro">
					numéro <xsl:value-of select="med:adresse/med:numéro"/>, 
				</xsl:if>
				<xsl:value-of select="med:adresse/med:rue"/>, 
				<xsl:value-of select="med:adresse/med:ville"/>, 
				<xsl:value-of select="med:adresse/med:codePostal"/>
			</td>
		
			<td>
				<ul>
					<xsl:apply-templates select="med:visite/med:acte"/>
				</ul>
			</td>
			<td>
				<button>
					<xsl:attribute name="onclick">
						openFacture(
						'<xsl:value-of select="med:prénom"/>',
						'<xsl:value-of select="med:nom"/>',
						'<xsl:value-of select="med:visite/med:acte"/>')
					</xsl:attribute>
					Facture
				</button>

			</td>
		</tr>
	</xsl:template>

	<!--
		Pour chaque med:acte de la med:visite pour le med:patient pris en charge par l'intervenant
		$destinedId : créer un élément d'une liste contenant :
		* le nom de l'acte dont l'$idSoin correspond à un @id du fichier actes.xml
	-->
	<xsl:template match="med:visite/med:acte">
		<xsl:variable name="idSoin" select="@id"/>
		<li>
			<xsl:value-of select="$actes/actes/acte[@id=$idSoin]"/>
		</li>
	</xsl:template>
	
</xsl:stylesheet>
	