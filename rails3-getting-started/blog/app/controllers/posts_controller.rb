class PostsController < ApplicationController
  before_filter :authenticate, :except => [:index, :show]

  # GET /posts
  # GET /posts.xml
  def index
    ### I think this innocuous line actually does quite a bit; I assume Post.all is a call to an ORM
    ### (?) Is this lazy execution, or does this line actually hit the DB?
    ### (?) What is the type of this expression? A primitive Ruby collection or a special ORM object
    @posts = Post.all

    ### I understand the block syntax (do |x| ... end), but what is respond_to?
    ### Hmm, http://www.tokumine.com/2009/09/13/how-does-respond_to-work-in-the-rails-controllers/
    ### OK, I see this is how you define different representations of the same resource
    ### (warning: REST buzzword factor dangerously high)
    ### Either by suffixing an extension (.xml, .json) or an Accept header.
    ### Some buzz about IE6 being broken with this feature, probably not true anymore.
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    ### Here's the ORM again, using the .find method
    
    ### Post is an ActiveRecord::Base (http://api.rubyonrails.org/classes/ActiveRecord/Base.html)
    ### Frustratingly, there's no real documentation for .find, although it seems to be used everywhere
    
    ### This params[] array must be defined on the controller. Where does the :post symbol come from?
    ### Perhaps this is a routing thing, I haven't examined the routes.rb file yet. Clearly, this must mean
    ### the "/1" part of the URL "/posts/1". In other languages, we'd use a querystring, but here it's part
    ### of the actual url.
    
    @post = Post.find(params[:id])

    respond_to do |format|
      ### What exactly are these? method calls with parens omitted?
      ### Why is the call to html() parameterless?
      ### How does it know to load {action}.html.erb?
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    ### Something I just noticed is that we're referring to @members without having defined them first
    ### Almost got tripped up between @posts above and @post here. I guess these variables are within the
    ### class/instance scope.

	### Where is @post accessed later? Oh, right, it must be in the .erb file

    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])

    ### Hmm, why is there no respond_to here? This is still a GET, I guess for the "editor" page.
    ### So fine, there's no XML because it's an "editor" page, but why not the respond_to with HTML only?
  end

  # POST /posts
  # POST /posts.xml
  def create
	### OK, our first POST.
    ### I guess params[:post] is a field from our form submit?
    @post = Post.new(params[:post])


	### Lots going on here. 
    ### I'm not a fan of the "if op_with_side_effect" style here, assuming save actually writes to the DB. 
    ### redirect_to is familiar, will be a 302. The :notice is interesting, will that live in the querystring? 
    ### I don't see any other way short of sessions. If it is a querystring echo, aren't they just asking for XSS issues?

    ### The XML part is interesting... what use is that really? Am I really going to submit a multipart/form-data form to a
    ### web-service? Or can I just use a=b (forgot the name of that simpler encoding)
    
    respond_to do |format|
      if @post.save
        format.html { redirect_to(@post, :notice => 'Post was successfully created.') }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  ### OK, gag. This is where things get a little strange for me. PUT, really? We're in zany-REST-purist land here.
  ### AFAIK, no browsers actually support PUT, but they can fake it by putting using POST and using a wacky
  ### method override HTTP header. I can't wait to see how this actually works from the browser.

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = Post.find(params[:id])

    ### update_attributes

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to(@post, :notice => 'Post was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end


  ### Interesting use of HTTP HEAD response, these are all so esoteric if you haven't read RFC2616 

  ### Will take some getting used to when it comes to telling an object to destroy itself, I am stuck
  ### in a procedural mindset: I'm used to delete(row) not entity.delete() 

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end
end
