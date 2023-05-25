import React, { useState } from "react";
import { canisterId, createActor} from "../../../declarations/token";
import { Principal } from "@dfinity/principal";
import { AuthClient } from "../../../../node_modules/@dfinity/auth-client/lib/cjs/index";

function Transfer() {

  const [recipientId, setId] = useState("");
  const [valueAmount, setAmount] = useState("");
  const [isDone, setDone] = useState(false);
  const [feedback, setFeedback] = useState("");
  const [isHidden, setHidden] = useState(true);
  
  async function handleClick() {

    setHidden(true);
    setDone(true);
    const recipient = Principal.fromText(recipientId);
    const amountToTransfer = Number(valueAmount);

    const authClient = await AuthClient.create();
    const identity = await authClient.getIdentity();
    const authenticatedCanister = createActor(canisterId, {
      agentOptions: {
        identity,
      },
    });  

    const result = await authenticatedCanister.transfer(recipient, amountToTransfer);
    setFeedback(result);
    setHidden(false);
    setDone(false);
  }

  return (
    <div className="window white">
      <div className="transfer">
        <fieldset>
          <legend>To Account:</legend>
          <ul>
            <li>
              <input
                type="text"
                id="transfer-to-id"
                value={recipientId}
                onChange={(e) => setId(e.target.value)}
              />
            </li>
          </ul>
        </fieldset>
        <fieldset>
          <legend>Amount:</legend>
          <ul>
            <li>
              <input
                type="number"
                id="amount"
                value={valueAmount}
                onChange={(e) => setAmount(e.target.value)}
                disabled={isDone}
              />
            </li>
          </ul>
        </fieldset>
        <p className="trade-buttons">
          <button 
            id="btn-transfer" 
            onClick={handleClick}
            disabled={isDone} 
          >
            Transfer
          </button>
        </p>
        <p hidden={isHidden}> {feedback} </p>
      </div>
    </div>
  );
}

export default Transfer;
