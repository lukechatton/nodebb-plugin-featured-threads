<div class="row featured-threads" itemscope itemtype="http://www.schema.org/ItemList">

	<ul class="bs-docs-social-buttons">
		<li>Latest Announcements:</li>

		<!-- BEGIN topics -->
		<li>
			<a data-placement="bottom" href="{config.relative_path}/topic/{topics.slug}" rel="tooltip" title="" data-original-title="{topics.category.numRecentReplies} replies">New Senior Moderators!</a>
		</li>
		<!-- END topics -->
	</ul>

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