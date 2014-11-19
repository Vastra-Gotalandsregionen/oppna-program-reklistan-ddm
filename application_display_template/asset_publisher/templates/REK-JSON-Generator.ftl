<#import '/ftl_macros/json.ftl' as json />
<script>
<@json.assetPublisherEntriesToJSON jsArrayName='dataDrugs' entries=entries locale=locale dateFormat="d MMMM yyyy" />
</script>