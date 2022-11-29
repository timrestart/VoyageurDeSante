<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:med="http://www.ujf-grenoble.fr/l3miage/medical">

	<xsl:output method="xml"/>

	<xsl:param name="destinedName">Pien</xsl:param>
	<xsl:variable name="actes" select="document('actes.xml', /)/ngap"/>

	<!--
		* Selectionner le med:patient dont le med:nom correspond à $destinedName
		comme patientCourant
		* Créer les element xml du $patientCourant : nom, prénom, sexe, naissance, numéroSS, adresse
		avec leur valeurs respectives
		* Appliquer une template pour trier les visites reçues par ce patient par @date
	-->
	<xsl:template match="/">
		<xsl:variable name="patientCourant" select="//med:patient[med:nom=$destinedName]"/>
		<xsl:element name="patient">
			<xsl:element name="nom">
				<xsl:value-of select="$patientCourant/med:nom"/>
			</xsl:element>
			<xsl:element name="prénom">
				<xsl:value-of select="$patientCourant/med:prénom"/>
			</xsl:element>
			<xsl:element name="sexe">
				<xsl:value-of select="$patientCourant/med:sexe"/>
			</xsl:element>
			<xsl:element name="naissance">
				<xsl:value-of select="$patientCourant/med:naissance"/>
			</xsl:element>
			<xsl:element name="numéroSS">
				<xsl:value-of select="$patientCourant/med:numéro"/>
			</xsl:element>
			<xsl:element name="adresse">
				<xsl:if test="$patientCourant/med:adresse/med:étage">
					<xsl:element name="étage">
						<xsl:value-of select="$patientCourant/med:adresse/med:étage"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="$patientCourant/med:adresse/med:numéro">
					<xsl:element name="numéro">
						<xsl:value-of select="$patientCourant/med:adresse/med:numéro"/>
					</xsl:element>
				</xsl:if>
				<xsl:element name="rue">
					<xsl:value-of select="$patientCourant/med:adresse/med:rue"/>
				</xsl:element>
				<xsl:element name="codePostal">
					<xsl:value-of select="$patientCourant/med:adresse/med:codePostal"/>
				</xsl:element>
				<xsl:element name="ville">
					<xsl:value-of select="$patientCourant/med:adresse/med:ville"/> 
				</xsl:element>
			</xsl:element>

			<xsl:apply-templates select="//med:patient[med:nom=$destinedName]/med:visite">
				<xsl:sort select="@date"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>

	<!--
		Pour chaque visite du $patientCourant : créer un élément visite contenant :
		* un attribut date
		* un element pour l'intervenant effectuant la visite (nom, prénom)
		* les actes reçu par l $patientCourant
	-->
	<xsl:template match="//med:patient[med:nom=$destinedName]/med:visite">
		<xsl:variable name="idIntervenant" select="@intervenant"/>
		<xsl:variable name="elemIntervenant" select="../../../med:infirmiers/med:infirmier[@id=$idIntervenant]"/>
		<xsl:element name="visite">
			<xsl:attribute name="date">
				<xsl:value-of select="@date"/>
			</xsl:attribute>
			<xsl:element name="intervenant">
				<xsl:element name="nom">
					<xsl:value-of select="$elemIntervenant/med:nom"/>
				</xsl:element>
				<xsl:element name="prénom">
					<xsl:value-of select="$elemIntervenant/med:prénom"/>
				</xsl:element>
			</xsl:element>

			<xsl:apply-templates select="med:acte"/>

		</xsl:element>
	</xsl:template>

	<!--
		Pour chaque med:acte de la med:visite courante :
		créer un élément acte contenant le nom de l'acte dont l'$idActe correspond
		à l'@id d'un acte dans actes.xml
	-->
	<xsl:template match="med:acte">
		<xsl:variable name="idActe" select="@id"/>
		<xsl:element name="acte">
			<xsl:value-of select="$actes/actes/acte[@id=$idActe]"/>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
