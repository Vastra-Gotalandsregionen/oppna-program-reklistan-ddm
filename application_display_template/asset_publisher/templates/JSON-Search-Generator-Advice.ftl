<script><@assetPublisherEntriesToJSON jsArrayName='dataSearchAdvice' entries=entries locale=locale /></script><#macro assetPublisherEntriesToJSON jsArrayName entries locale><#assign uniqueCategories = [] />${jsArrayName} = [<#list entries as entry><#assign docXml = saxReaderUtil.read(entry.getAssetRenderer().getArticle().getContentByLocale(locale) ) /><#assign assetRenderer = entry.getAssetRenderer() /><#assign viewURL = assetPublisherHelper.getAssetViewURL(renderRequest, renderResponse, entry) /><#assign viewURL = assetRenderer.getURLViewInContext(renderRequest, renderResponse, viewURL) /><@_assetPublisherEntriesToJSONFunc nodeStart = docXml.selectNodes("//root/*") entryTitle = entry.getTitle(locale) /><#if entry_has_next>,</#if></#list>]</#macro><#macro _assetPublisherEntriesToJSONFunc nodeStart entryTitle><#list nodeStart as node><#local nodes2 = node.selectNodes("dynamic-element") /><#if node.valueOf("@name") == 'heading'><#if (node_index > 0)>,</#if>{"chapter": "${entryTitle?js_string}","section": "${node.valueOf("dynamic-content/text()")?js_string}","content": "<#else><#if (node.valueOf("dynamic-content/text()")?length > 0)>${node.valueOf("dynamic-content/text()")?js_string} </#if></#if><#if nodes2?has_content><@_assetPublisherEntriesToJSONFunc nodeStart = nodes2 entryTitle = entryTitle /></#if><#if node.valueOf("@name") == 'heading'>"}</#if></#list></#macro>


<#--
<script>
	<@assetPublisherEntriesToJSON jsArrayName='dataSearchAdvice' entries=entries locale=locale />
</script>


<#macro assetPublisherEntriesToJSON jsArrayName entries locale>
	<#assign uniqueCategories = [] />
	${jsArrayName} = 
	[	
	<#list entries as entry>
		<#assign docXml = saxReaderUtil.read(entry.getAssetRenderer().getArticle().getContentByLocale(locale) ) />
		<#assign assetRenderer = entry.getAssetRenderer() />
		<#assign viewURL = assetPublisherHelper.getAssetViewURL(renderRequest, renderResponse, entry) />
		<#assign viewURL = assetRenderer.getURLViewInContext(renderRequest, renderResponse, viewURL) />

		<@_assetPublisherEntriesToJSONFunc nodeStart = docXml.selectNodes("//root/*") entryTitle = entry.getTitle(locale) />

		<#if entry_has_next>

,

		</#if>
	</#list>
	]
</#macro>

<#macro _assetPublisherEntriesToJSONFunc nodeStart entryTitle>
	<#list nodeStart as node>
			<#local nodes2 = node.selectNodes("dynamic-element") />
			<#if node.valueOf("@name") == 'heading'>
				<#if (node_index > 0)>
					,
				</#if>
				{
				"chapter": "${entryTitle?js_string}",
				"section": "${node.valueOf("dynamic-content/text()")?js_string}",
				"content": "
			<#else>
				<#if (node.valueOf("dynamic-content/text()")?length > 0)>${node.valueOf("dynamic-content/text()")?js_string} </#if>
			</#if>

			<#if nodes2?has_content>
				<@_assetPublisherEntriesToJSONFunc nodeStart = nodes2 entryTitle = entryTitle />
			</#if>

			<#if node.valueOf("@name") == 'heading'>
				"
				}
			</#if>
	</#list>
</#macro>
-->