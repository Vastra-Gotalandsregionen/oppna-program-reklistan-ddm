

<link href="/reklistan-theme/css/custom.css?browserId=other&themeId=reklistantheme_WAR_reklistantheme&languageId=en_US&b=6210&t=${.now?datetime?iso_local}" rel="stylesheet" type="text/css">
<div class="preview-wrapper">

  <div id="title-target"></div>
  <script id="title-template" type="text/x-handlebars-template">
    <h1 class="preview-article-title">{{title}}</h1>
  </script>

  <div class="preview-settings">
    <a href="#" class="open-self-new-window" target="_blank">Öppna i nytt eget fönster (för utskrift)</a>
    <label><input type="checkbox" class="chekbox-show-preview checkbox-show-preview-published-draft" name="preview-settings" value="show-draft-published" checked>Visa utkast/publicerad</label>
    <label><input type="checkbox" class="chekbox-show-preview checkbox-show-preview-diff" name="preview-settings" value="show-diff" checked>Visa diff</label>
  </div>

  <div class="preview-box preview-box-draft">
    <div class="preview-box-heading">Utkast<span class="no-print"> (<a href="#" class="toggle-show-published">visa publicerad</a>)</span></div>
    <div id="draft-target"></div>
  </div>
  <div class="preview-box preview-box-published hide-me">
    <div class="preview-box-heading">Publicerad<span class="no-print"> (<a href="#" class="toggle-show-draft">visa utkast</a>)</span></div>
    <div id="published-target"></div>
  </div>    
  <div class="preview-box preview-box-diff">
    <div class="preview-box-heading">Diff</div>
    <div id="diff-target"></div>
  </div>
</div>

<script>
AUI().ready('aui-base', function(A) {
    'use strict';

    var urlJquery = '/reklistan-theme/custom-lib/jquery/jquery-1.11.2.min.js';
    var urlSwag = '/reklistan-theme/custom-lib/swag/swag.min.js';
    var urlHandlebars = '/reklistan-theme/lib/handlebars/handlebars.min.js';
    var urlDiff = '/reklistan-theme/custom-lib/diff.js/diff.js';
    var urlDiffPreviews = '/reklistan-theme/js/diff-previews.js';
    var urlHbsTemplate = '/reklistan-theme/handlebars/details-drugs.hbs';
    var urlArticlePublished = "/api/jsonws/skinny-web.skinny/get-skinny-journal-article/group-id/${articleGroupId}/article-id/${.vars['reserved-article-id'].data}/status/0/locale/${locale}";
    var urlArticleDraft = "/api/jsonws/skinny-web.skinny/get-skinny-journal-article/group-id/${articleGroupId}/article-id/${.vars['reserved-article-id'].data}/status/-1/locale/${locale}";    


    // Load jQuery
    A.Get.js(urlJquery, function (err) {
        if (err) {
            alert('Could not load jQuery, URL: ' + urlJquery);
            return;
        }
        // Load all javascript/handlebar templates/json needed.
        $(function() {
          $.when(
            $.getScript(urlHandlebars),
            $.getScript(urlSwag),
            $.getScript(urlDiff),
            $.getScript(urlDiffPreviews),
            $.ajax(urlHbsTemplate),
            $.ajax(urlArticlePublished),
            $.ajax(urlArticleDraft)
          )
          .then(function(voidHandlebars, voidSwag, voidDiff, voidDiffPreviews, hbsTemplate, articlePublished, articleDraft) {
            renderDiffPreviews(articlePublished[0], articleDraft[0], hbsTemplate[0]);
          })
          .fail(function(err) {
            alert('Could not load all resources needed\n\n' + JSON.stringify(err));
          });
        });

    });
});
</script>
