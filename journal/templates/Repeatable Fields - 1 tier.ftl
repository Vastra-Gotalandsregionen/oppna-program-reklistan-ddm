<#if tierone.getSiblings()?has_content>
	<#list tierone.getSiblings() as cur_tierone>
	
	${cur_tierone.getData()}
	
	</#list>
</#if>