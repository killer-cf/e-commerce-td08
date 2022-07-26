require 'rails_helper'

describe 'Cliente adiciona um item ao carrinho' do
  it 'com sucesso' do
    create :exchange_rate
    client = create :client
    product = create(:product, name: 'Monitor 8k', status: :active)
    StockProduct.destroy_all
    create :stock_product, product: product, quantity: 10
    create(:price, product: product, admin: product.category.admin, start_date: Time.zone.today,
                   end_date: 90.days.from_now, value: 1500.00)

    login_as client, scope: :client
    visit root_path
    click_on 'Monitor 8k'
    click_on 'Adicionar ao carrinho'
    product.reload

    expect(page).to have_content 'Monitor 8k adicionado ao carrinho!'
    expect(ProductItem.count).to eq 1
    expect(product.stock_product.quantity).to eq 9
  end

  it 'e não tem o produto escolhido' do
    create :exchange_rate
    client = create :client
    product = create(:product, name: 'Monitor 8k', status: :active)
    create :price, product: product

    login_as client, scope: :client
    visit root_path
    click_on 'Monitor 8k'
    click_on 'Adicionar ao carrinho'

    expect(page).to have_content 'Monitor 8k acabou!'
    expect(ProductItem.count).to eq 0
  end

  it 'com falha' do
    create :exchange_rate
    client = create :client
    product = create(:product, name: 'Monitor 8k', status: :active)
    StockProduct.destroy_all
    create :stock_product, product: product, quantity: 10
    create(:price, product: product, admin: product.category.admin, start_date: Time.zone.today,
                   end_date: 90.days.from_now, value: 1500.00)
    allow(ProductItem).to receive(:new).and_raise(ActiveRecord::ActiveRecordError)

    login_as client, scope: :client
    visit root_path
    click_on 'Monitor 8k'
    click_on 'Adicionar ao carrinho'

    expect(page).to have_content 'Não foi possível adicionar ao carrinho'
    expect(page).to have_current_path product_path(product)
  end
end
