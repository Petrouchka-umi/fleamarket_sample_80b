class ProductsController < ApplicationController
  before_action :move_to_index, except: [:index, :show, :search]

  def index
    @products = Product.includes(:images).order('created_at DESC')
  end

  def show
    @product = Product.find(params[:id])
    @grandchild = @product.category
    @child = @grandchild.parent
    @parent = @child.parent
  end

  def new
    @product = Product.new
    @product.images.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to root_path, notice: '商品が出品されました'
    else
      flash.now[:alert] = '商品情報に未入力があります'
      render :new
    end
  end

  def destroy
  end

  def edit
  end

  def update
  end

  def check
  end

  def search
    @products = Product.search(params[:keyword])
  end

  def get_category_children
    respond_to do |format| 
      format.html
      format.json do
        @category_children = Category.find("#{params[:parent_id]}").children
      end
    end
  end
  
  def get_category_grandchildren
    respond_to do |format| 
      format.html
      format.json do
        @category_grandchildren = Category.find("#{params[:child_id]}").children
      end
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :cost, :description, :prefecture_id, :delivery_id, :brand, :size_id, :category_id, :status_id, images_attributes: [:url, :_destroy, :id]).merge(user_id: current_user.id)
  end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end

end
