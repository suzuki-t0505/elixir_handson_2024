defmodule HouseholdAccountBookApp.PurchasesTest do
  use HouseholdAccountBookApp.DataCase

  alias HouseholdAccountBookApp.Purchases

  describe "purchases" do
    alias HouseholdAccountBookApp.Purchases.Purchase

    import HouseholdAccountBookApp.PurchasesFixtures

    @invalid_attrs %{name: nil, date: nil, money: nil}

    test "list_purchases/0 returns all purchases" do
      purchase = purchase_fixture()
      assert Purchases.list_purchases() == [purchase]
    end

    test "get_purchase!/1 returns the purchase with given id" do
      purchase = purchase_fixture()
      assert Purchases.get_purchase!(purchase.id) == purchase
    end

    test "create_purchase/1 with valid data creates a purchase" do
      valid_attrs = %{name: "some name", date: ~D[2024-07-21], money: 42}

      assert {:ok, %Purchase{} = purchase} = Purchases.create_purchase(valid_attrs)
      assert purchase.name == "some name"
      assert purchase.date == ~D[2024-07-21]
      assert purchase.money == 42
    end

    test "create_purchase/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Purchases.create_purchase(@invalid_attrs)
    end

    test "update_purchase/2 with valid data updates the purchase" do
      purchase = purchase_fixture()
      update_attrs = %{name: "some updated name", date: ~D[2024-07-22], money: 43}

      assert {:ok, %Purchase{} = purchase} = Purchases.update_purchase(purchase, update_attrs)
      assert purchase.name == "some updated name"
      assert purchase.date == ~D[2024-07-22]
      assert purchase.money == 43
    end

    test "update_purchase/2 with invalid data returns error changeset" do
      purchase = purchase_fixture()
      assert {:error, %Ecto.Changeset{}} = Purchases.update_purchase(purchase, @invalid_attrs)
      assert purchase == Purchases.get_purchase!(purchase.id)
    end

    test "delete_purchase/1 deletes the purchase" do
      purchase = purchase_fixture()
      assert {:ok, %Purchase{}} = Purchases.delete_purchase(purchase)
      assert_raise Ecto.NoResultsError, fn -> Purchases.get_purchase!(purchase.id) end
    end

    test "change_purchase/1 returns a purchase changeset" do
      purchase = purchase_fixture()
      assert %Ecto.Changeset{} = Purchases.change_purchase(purchase)
    end
  end
end
