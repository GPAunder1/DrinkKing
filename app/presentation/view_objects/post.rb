# frozen_string_literal: true

module Views
  class Post
    def initialize(post)
      @post = post
    end

    def text
      @post.text
    end

    def img_url
      @post.img_url
    end

    def post_time
      @post.post_time
    end
  end
end
