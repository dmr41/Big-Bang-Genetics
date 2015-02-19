class UsersController < ApplicationController

  def index
    @users = User.all.page params[:page]
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: "User created!"
    else
      render :new
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice: "User deleted"
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      single_gene = @user.my_genes.last
      gene_name = ConsensusCancerGene.find_by(id: single_gene)
      redirect_to cancers_path, notice: "#{gene_name.gene_symbol} added to your collection!"
    else
      render :edit
    end
  end

  private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :age, :email, {:my_genes=> []})
    end

end
