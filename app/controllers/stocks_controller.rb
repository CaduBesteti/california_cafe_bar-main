class StocksController < AuthenticatedController
  def new
    @stock = Stock.new
  end

def create
  default_barcode = "DEFAULT_BARCODE_#{SecureRandom.hex(3)}"
  @stock = Stock.new(stock_params.merge(user: current_user, barcode: stock_params[:barcode].presence || default_barcode))

  if @stock.save
    redirect_to new_stock_path, notice: 'Stock created successfully.'  # REDIRECIONA para evitar o erro Turbo
  else
    render :new, status: :unprocessable_entity  # Renderiza o formulário com erros
  end
end

  

  def amount
    stock = Stock.find(params[:id])
    render json: { amount: stock.amount }
  end

  def show
    @stock = Stock.find(params[:id])
  end

  def index
    @stocks = Stock.all
  end

  def destroy
    @stock = Stock.find(params[:id])
    @stock.destroy
    redirect_to stocks_path
  end

  def edit
    @stock = Stock.find(params[:id])
  end

  def update
    @stock = Stock.find(params[:id])

    if @stock.update(stock_params)
      redirect_to @stock, notice: 'Stock was successfully updated.'
    else
      render :edit
    end
  end

  private

  def stock_params
    params.require(:stock).permit(:name, :amount, :price, :barcode, :is_salgado)
  end
end
  def search
    barcode = params[:barcode]
    @stock = Stock.find_by(barcode: barcode)

    respond_to do |format|
      if @stock
        format.html { redirect_to @stock, notice: "Produto encontrado: #{@stock.name}" }
      else
        format.html { redirect_to root_path, alert: "Produto não encontrado para o código #{barcode}" }
      end
    end
  end
  def scan
    barcode = params[:barcode]

    # Verifica se o código de barras existe no banco de dados
    @stock = Stock.find_by(barcode: barcode)

    if @stock
      render json: { status: 'success', stock: @stock }
    else
      render json: { status: 'error', message: 'Produto não encontrado' }, status: 404
    end
  end
  