import { Eth } from "state/Eth"; // Eth state provider
import { Token } from "state/Token"; // Token state provider
import type { ReactElement } from "react"; // Types

/**
 * State providing wrapper
 * @param {ReactElement | ReactElement[]} children to inject
 * @returns {ReactElement} wrapper
 */
export default function StateProvider({
  children,
}: {
  children: ReactElement | ReactElement[];
}): ReactElement {
  return (
    <>
      <Eth.Provider>
        <Token.Provider>{children}</Token.Provider>
      </Eth.Provider>
    </>
  );
}