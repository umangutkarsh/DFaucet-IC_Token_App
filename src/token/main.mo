import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";

actor Token {

    Debug.print("Hello");

    let owner : Principal = Principal.fromText("7hka6-33hp4-m5eqt-b5lgt-ckuq6-okjj6-mvpgs-nrpxn-vzy3t-qcpta-cae");
    let totalSupply : Nat = 1000000000;
    let symbol : Text = "DUMA";

    private stable var balanceEntries: [(Principal, Nat)] = [];
    private var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);
    if (balances.size() < 1) {
        balances.put(owner, totalSupply);
    };


    public query func balanceOf(who: Principal) : async Nat {

        let balance : Nat = switch (balances.get(who)) {
            case null 0;
            case (?result) result;
        };

        return balance;
    };

    public query func getSymbol() : async Text {
        return symbol;
    }; 

    public shared(msg) func payOut() : async Text {

        Debug.print(debug_show (msg.caller));

        if (balances.get(msg.caller) == null) {
            let amount = 10000;
            let result = await transfer(msg.caller, amount);
            return result;
        } 

        else {
            return "Already Claimed!";
        }
        
    };

    public shared(msg) func transfer(to: Principal, amount: Nat) : async Text {

      let fromBalance = await balanceOf(msg.caller);
      if (fromBalance > amount) {

        let newFromBalance : Nat = fromBalance - amount;
        balances.put(msg.caller, newFromBalance);

        let toBalance = await balanceOf(to);
        let newTobalance = toBalance + amount;
        balances.put(to, newTobalance);

        return "Success"; 
      }

      else {
        return "Insufficient funds";
      }
    };

    system func preupgrade() {
        balanceEntries := Iter.toArray(balances.entries());
    };

    system func postupgrade() {
        balances := HashMap.fromIter<Principal, Nat>(balanceEntries.vals(), 1, Principal.equal, Principal.hash);
        if (balances.size() < 1) {
            balances.put(owner, totalSupply);
        }
    };

}