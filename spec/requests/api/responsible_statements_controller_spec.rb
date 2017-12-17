require 'spec_helper'
require 'savon'

describe Api::ResponsibleStatementsController do
  HTTPI.adapter = :rack
  HTTPI::Adapter::Rack.mount 'application', Agendas::Application

  describe "inicioExpediente" do

    it "Should return error when codTipoExpediente is not provided" do
      application_base = "http://application"
      client = Savon::Client.new(
                wsdl: application_base + api_responsible_statements_wsdl_path)

      response = client.call(:inicio_expediente, message: {})

      body = response.body[:inicio_expediente_response]
      expect(body[:cod_retorno]).to eq '0'
      expect(body[:desc_error]).to  eq "codTipoExpediente cannot be blank"
      expect(body[:id_expediente]).to be_blank
      expect(body[:ref_expediente]).to  be_blank
    end

    it "Should return error when xmlDatosEntrada is not provided" do
      application_base = "http://application"
      client = Savon::Client.new(
                wsdl: application_base + api_responsible_statements_wsdl_path)

      response = client.call(:inicio_expediente,
                             message: { codTipoExpediente: "1234" })

      body = response.body[:inicio_expediente_response]
      expect(body[:cod_retorno]).to eq '0'
      expect(body[:desc_error]).to  eq "xmlDatosEntrada cannot be blank"
      expect(body[:id_expediente]).to be_blank
      expect(body[:ref_expediente]).to be_blank
    end

    it "Should return error when usuario is not provided" do
      application_base = "http://application"
      client = Savon::Client.new(
                wsdl: application_base + api_responsible_statements_wsdl_path)

      response = client.call(:inicio_expediente,
                             message: {
                              codTipoExpediente: "1234",
                              xmlDatosEntrada: "sample" })

      body = response.body[:inicio_expediente_response]
      expect(body[:cod_retorno]).to eq '0'
      expect(body[:desc_error]).to  eq "usuario cannot be blank"
      expect(body[:id_expediente]).to be_blank
      expect(body[:ref_expediente]).to be_blank
    end

    it "Should return success when organization could be created" do
      skip "until implementation"
      application_base = "http://application"
      client = Savon::Client.new(
                wsdl: application_base + api_responsible_statements_wsdl_path)

      response = client.call(:inicio_expediente,
                             message: {
                              codTipoExpediente: "1234",
                              xmlDatosEntrada: File.read("spec/fixtures/newResponsibleStatement.xml"),
                              usuario: "WFORM" })

      body = response.body[:inicio_expediente_response]
      expect(body[:cod_retorno]).to eq '0'
      expect(body[:desc_error]).to  eq "usuario cannot be blank"
      expect(body[:id_expediente]).to be_blank
      expect(body[:ref_expediente]).to be_blank
    end
  end

end