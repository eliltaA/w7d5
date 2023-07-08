class SubsController < ApplicationController
    def index 
        @subs = Sub.all
        render :index
    end

    def show 
        @sub = Sub.find_by(id: params[:id])
        render :show
    end

    def new 
        @sub = Sub.new
        render :new
    end

    def create 
        @sub = Sub.new(sub_params)
        @sub.moderator_id = current_user.id
        if @sub.save
            redirect_to subs_url
        else
            flash.now[:errors] = @sub.errors.full_messsages
            render :new
        end
    end

    def update 
        @sub = Sub.find_by(id: params[:id])
        if current_user.id == @sub.moderator_id
            if @sub && @sub.update(sub_params)
                redirect_to sub_url(@sub)
            else
                flash.now[:errors] = ["sub not found"]
                render :edit
            end
       end
    end

    def edit 
        @sub = Sub.find_by(id: params[:id])
        render :edit
    end

    private
    def sub_params
        params.require(:sub).permit(:title, :description)
    end
end
