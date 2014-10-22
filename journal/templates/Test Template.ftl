<#--
Web content templates are used to lay out the fields defined in a web
content structure.

Please use the left panel to quickly add commonly used variables.
Autocomplete is also available and can be invoked by typing "${".
-->


<#list Huvudnod.getSiblings() as cur_Huvudnod>
    Huvudnod: ${cur_Huvudnod.getData()}
    <#list Child_HTML.getSiblings() as cur_Child_HTML>
        Child_HTML: ${cur_Child_HTML.getData()}
    </#list>
    <hr>
</#list>