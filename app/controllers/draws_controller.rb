class DrawsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  AVAILABLE_NAMES = ["Fabio", "Danilo", "Thalita", "Danielle", "Suzane"].freeze

  GIFT_SUGGESTIONS = {
    "Fabio" => "sugestão de presentes: cigarro, cachaça ou buceta",
    "Thalita" => "sugestão de presente: piroca de borracha, Tarô, ou alguma coisa que remeta ao Olaf do Frozen",
    "Suzane" => "sugestão de presente: um pinto preto de 18cm",
    "Danielle" => "sugestão de presente: maconha",
    "Danilo" => "sugestão de presente: um fleshlight, vinho, uma pá coletora de coco de gato de metal"
  }.freeze

  def index
  end

  def create
    user_name = params[:user_name]

    if user_name.blank?
      render json: { error: "Nome não pode estar em branco" }, status: :unprocessable_entity
      return
    end

    # Verifica se o usuário já fez um sorteio (case-insensitive)
    existing_draw = Draw.find_by("LOWER(user_name) = ?", user_name.downcase)
    if existing_draw
      render json: { error: "Você já realizou um sorteio!", drawn_name: existing_draw.drawn_name }, status: :unprocessable_entity
      return
    end

    # Pega os nomes já sorteados
    drawn_names = Draw.pluck(:drawn_name)

    # Encontra os nomes disponíveis (excluindo nomes já sorteados e o próprio nome do usuário - case-insensitive)
    available_names = AVAILABLE_NAMES - drawn_names
    available_names = available_names.reject { |name| name.casecmp?(user_name) }

    if available_names.empty?
      render json: { error: "Não há nomes disponíveis para sorteio!" }, status: :unprocessable_entity
      return
    end

    # Sorteia um nome aleatório dos disponíveis
    drawn_name = available_names.sample

    # Salva no banco
    draw = Draw.create(user_name: user_name, drawn_name: drawn_name)

    if draw.persisted?
      render json: {
        drawn_name: drawn_name,
        gift_suggestion: GIFT_SUGGESTIONS[drawn_name]
      }, status: :ok
    else
      render json: { error: "Erro ao salvar sorteio" }, status: :unprocessable_entity
    end
  end
end
