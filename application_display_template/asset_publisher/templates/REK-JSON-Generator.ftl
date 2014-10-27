<#--
This ADT will create a bif fat Javascript object.

TODO: ESCAPE EVERYTHING TO MAKE IT JSON-SAFE
-->
<#setting locale=locale>



<script>
bigFatData = [
<#list entries as entry>
{
	<@printValue value = entry.getTitle(locale) tween = ','/>
	heading: [
		<#assign docXml = saxReaderUtil.read(entry.getAssetRenderer().getArticle().getContentByLocale(locale) ) />
		<#assign headingNodes = docXml.selectNodes("//dynamic-element[@name='heading']") />
		<#list headingNodes as heading>
		{
			<@printValue value = heading.valueOf("dynamic-content/text()") tween = ','/>

			<#assign infoboxNodes = heading.selectNodes("dynamic-element[@name='infobox']") />
			infobox: [
			<#list infoboxNodes as infobox>
			{
				<@printValue value = infobox.valueOf("dynamic-content/text()") tween = ''/>
			}<#if infobox_has_next>,</#if>
			</#list>
			],

			subheading1: [
				<#assign subheading1Nodes = heading.selectNodes("dynamic-element[@name='subheading1']") />
				<#list subheading1Nodes as subheading1>
				{
					<@printValue value = subheading1.valueOf("dynamic-content/text()") tween = ','/>

					subheading2: [
						<#assign subheading2Nodes = subheading1.selectNodes("dynamic-element[@name='subheading2']") />
						<#list subheading2Nodes as subheading2>
						{
							<@printValue value = subheading2.valueOf("dynamic-content/text()") tween = ','/>

							area: [
								<#assign areaNodes = subheading2.selectNodes("dynamic-element[@name='area']") />
								<#list areaNodes as area>
								{
									<@printValue value = area.valueOf("dynamic-content/text()") tween = ','/>

									substance: [
										<#assign substanceNodes = area.selectNodes("dynamic-element[@name='substance']") />
										<#list substanceNodes as substance>
										{
											<@printValue value = substance.valueOf("dynamic-content/text()") tween = ','/>

												<#assign replaceableNodes = substance.selectNodes("dynamic-element[@name='replaceable']") />
												<#list replaceableNodes as replaceable>
													replaceable: "${replaceable.valueOf("dynamic-content/text()")}",
												</#list>

											drug: [
												<#assign drugNodes = substance.selectNodes("dynamic-element[@name='drug']") />
												<#list drugNodes as drug>
												{
													<@printValue value = drug.valueOf("dynamic-content/text()") tween = '' />
												}<#if drug_has_next>,</#if>
												</#list>
											]

										}<#if substance_has_next>,</#if>
										</#list>
									]

								}<#if area_has_next>,</#if>
								</#list>
							]

						}<#if subheading2_has_next>,</#if>
						</#list>
					]

				}<#if subheading1_has_next>,</#if>
				</#list>
			]

		}<#if heading_has_next>,</#if>
		</#list>
	]
}<#if entry_has_next>,</#if>
</#list>
]
</script>




<#macro printValue value tween>
	<#if value?has_content>
		fieldValue: "${value}"${tween}
	<#else>
		fieldValue: ""${tween}
	</#if>
</#macro>