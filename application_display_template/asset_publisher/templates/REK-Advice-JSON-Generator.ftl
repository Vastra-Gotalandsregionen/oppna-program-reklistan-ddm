<#import '/ftl_macros/json.ftl' as json />
<script>
<@json.assetPublisherEntriesToJSON jsArrayName='dataAdvice' entries=entries locale=locale dateFormat="d MMMM yyyy" />
</script>