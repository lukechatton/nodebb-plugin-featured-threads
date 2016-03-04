<h1>test</h1>
<div class="row featured-threads" itemscope itemtype="http://www.schema.org/ItemList">
	<!-- BEGIN topics -->
	<div component="categories/category" class="<!-- IF topics.category.class -->{topics.category.class}<!-- ELSE -->col-md-3 col-sm-6 col-xs-12<!-- ENDIF topics.category.class --> category-item" data-cid="{topics.category.cid}" data-numRecentReplies="{topics.category.numRecentReplies}">
		<meta itemprop="name" content="{topics.category.name}">
			<a style="color: {topics.category.color};" href="{config.relative_path}/topic/{topics.slug}" itemprop="url">

			</a>
	</div>
	<!-- END topics -->
</div>
<br />

<script type="text/javascript">
(function() {
	$('span.timeago').timeago();

	var featuredThreadsWidget = app.widgets.featuredThreads;

	var numPosts = parseInt('{numPostsPerTopic}', 10); // TODO replace with setting from widget
	numPosts = numPosts || 8;

	if (!featuredThreadsWidget) {
		featuredThreadsWidget = {};
		featuredThreadsWidget.onNewPost = function(data) {
			var tid;
			if(data && data.posts && data.posts.length) {
				tid = data.posts[0].tid;
			}

			var category = $('.home .category-item[data-tid="' + tid + '"]');
			var recentPosts = category.find('.post-preview');
			var insertBefore =  recentPosts.first();

			if (!insertBefore.length) {
				return;
			}

			parseAndTranslate(data.posts, function(html) {
				html.hide()
					.insertBefore(insertBefore)
					.fadeIn();

				app.createUserTooltips();
				if (category.find('.post-preview').length > numPosts) {
					recentPosts.last().remove();
				}
			});
		}

		app.widgets.featuredThreads = featuredThreadsWidget;
		socket.on('event:new_post', app.widgets.featuredThreads.onNewPost);
	}

	function parseAndTranslate(posts, callback) {
		templates.preload_template('widgets/featured-topics/posts', function() {
			var html = templates['widgets/featured-topics/posts'].parse({
				topics: {
					posts: posts
				}
			});

			translator.translate(html, function(translatedHTML) {
				translatedHTML = $(translatedHTML);
				translatedHTML.find('img').addClass('img-responsive');
				translatedHTML.find('span.timeago').timeago();
				callback(translatedHTML);
			});
		});
	}
}());

</script>