<script>
	<@assetPublisherEntriesToJSON jsArrayName='dataDrugs' entries=entries locale=locale dateFormat="d MMMM yyyy" />
</script>


<#macro assetPublisherEntriesToJSON jsArrayName entries locale dateFormat>
	<#assign uniqueCategories = [] />
	${jsArrayName} = {
	entries: [	
	<#list entries as entry>
		<#assign docXml = saxReaderUtil.read(entry.getAssetRenderer().getArticle().getContentByLocale(locale) ) />
		<#assign assetRenderer = entry.getAssetRenderer() />
		<#assign viewURL = assetPublisherHelper.getAssetViewURL(renderRequest, renderResponse, entry) />
		<#assign viewURL = assetRenderer.getURLViewInContext(renderRequest, renderResponse, viewURL) />
		{
		_index: ${entry_index},
		_title: "${entry.getTitle(locale)}",
		_publishDate: "${entry.publishDate?datetime?string(dateFormat)}",
		_entryId: ${entry.entryId},
		_viewURL: "${viewURL}",
		_categories: [
		<#list entry.getCategories() as category >
			<#if (uniqueCategories?seq_contains(category.getTitle(locale)?js_string) == false ) >
				<#assign uniqueCategories = uniqueCategories + [ category.getTitle(locale)?js_string ] />
			</#if>
			"${category.getTitle(locale)?js_string}"
			<#if category_has_next>,</#if>
		</#list>
		],
		<@_assetPublisherEntriesToJSONFunc nodeStart = docXml.selectNodes("//root/*") />
		}
		<#if entry_has_next>,</#if>
	</#list>
	],
	meta: {
		categories: [
			<#list uniqueCategories as cat >
				"${cat}"
				<#if cat_has_next>,</#if>
			</#list>
		]
		}
	};
</#macro>

<#macro _assetPublisherEntriesToJSONFunc nodeStart>
	<#local prevName = '' />
	<#list nodeStart as node>
			<#local nodes2 = node.selectNodes("dynamic-element") />
			<#if (prevName == node.valueOf("@name"))>
				,
			<#else>
				<#if prevName != ''>],</#if>
				${node.valueOf("@name")?js_string}: [
			</#if>
			<#local prevName = node.valueOf("@name")/>
			{
			fieldValue: "${node.valueOf("dynamic-content/text()")?js_string}"
			<#if nodes2?has_content>,<@_assetPublisherEntriesToJSONFunc nodeStart = nodes2 /></#if>
			}
			<#if !node_has_next>]</#if>
	</#list>
</#macro>