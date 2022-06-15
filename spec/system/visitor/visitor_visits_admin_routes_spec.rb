require 'rails_helper'

describe 'Visitante não autenticado tenta acessar' do
  it 'a tela de cadastros de administradores pendentes' do
    visit pending_admins_path

    expect(page).to have_current_path new_admin_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'a tela de cadastro de nova categoria' do
    visit new_category_path

    expect(page).to have_current_path new_admin_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'a tela de detalhes de uma categoria' do
    category = create(:category, admin: create(:admin))

    visit category_path(category)

    expect(page).to have_current_path new_admin_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'a tela de cadastro de novo produto' do
    visit new_product_path

    expect(page).to have_current_path new_admin_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end
end