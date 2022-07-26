require 'rails_helper'

describe 'Cliente remove item do carrinho' do
  it 'com sucesso' do
    create :exchange_rate
    client = create :client
    product = create :product, name: 'Mouse'
    StockProduct.destroy_all
    create :stock_product, product: product, quantity: 10
    create(:price, product:)
    create(:product_item, product: product, client: client)

    login_as client, scope: :client
    visit shopping_cart_path
    click_on 'Remover Produto'
    product.reload

    expect(page).not_to have_content 'Mouse'
    expect(page).to have_content 'Produto Removido!'
    expect(ProductItem.count).to eq 0
    expect(product.stock_product.quantity).to eq 11
  end
end
