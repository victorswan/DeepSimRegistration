import torchreg.transforms.functional as transforms
from torchreg.nn import Identity
import torch
import matplotlib.pyplot as plt
import numpy as np


class Fig:
    def __init__(self, rows=1, cols=1, title=None, figsize=None):
        """
        instantiates a plot.
        Parameters:
            rows: how many plots per row
            cols: how many plots per column
            title: title of the figure
        """
        # instantiate plot
        self.fig, self.axs = plt.subplots(
            nrows=rows, ncols=cols, dpi=300, figsize=figsize
        )

        # set title
        self.fig.suptitle(title)

        # extend empty dimensions to array
        if cols == 1:
            self.axs = np.array([self.axs])
        if rows == 1:
            self.axs = np.array([self.axs])

        # hide all axis
        for row in self.axs:
            for ax in row:
                ax.axis("off")

    def plot_img(self, row, col, image, title=None, vmin=None, vmax=None):
        """
        plots a tensor of the form C x H x W at position row, col.
        C needs to be either C=1 or C=3
        Parameters:
            row: the row to plot the image
            col: the clolumn to plot the image
            image: Tensor of shape C x H x W
            title: optional title
            vmin: optinal lower bound for color scaling
            vmax: optional higher bound for color scaling
        """
        # convert to numpy
        img = transforms.image_to_numpy(image)
        if len(img.shape) == 2:
            # plot greyscale image
            self.axs[row, col].imshow(img, cmap="gray", vmin=vmin, vmax=vmax, interpolation='none')
        elif len(img.shape) == 3:
            # last channel is color channel
            self.axs[row, col].imshow(img)
        self.axs[row, col].set_aspect("equal")
        self.axs[row, col].title.set_text(title)
        return self

    def plot_contour(self, row, col, mask, width=3, rgba=(36, 255, 12, 255)):
        """
        imposes a contour-line overlay onto a plot
        Overlay needs to be of the form 1 x H x W, with classes 0 and 1
        Parameters:
            row: the row to plot the image
            col: the clolumn to plot the image
            mask: Tensor of shape C x H x W
            width: thickness of contours.
            rgba: color of the contour lines. RGB or RGBA formats
        """
        # convert to numpy
        mask = transforms.image_to_numpy(mask)
        if len(rgba) == 3:
            # add alpha-channel
            rgba = (*rgba, 255)

        # find countours
        import cv2
        outline = np.zeros((*mask.shape[:2], 4), dtype=np.uint8) * 255
        cnts = cv2.findContours(mask.astype(np.uint8), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        cnts = cnts[0] if len(cnts) == 2 else cnts[1]
        for c in cnts:
            cv2.drawContours(outline, [c], -1, rgba, thickness=width)
        self.axs[row, col].imshow(outline.astype(np.float) / 255, vmin=0, vmax=1, interpolation='none', alpha=1.0)

        return self

    def plot_overlay_class_mask(self, row, col, class_mask, num_classes, colors, alpha=0.4):
        """
        imposes a color-coded class_mask onto a plot
        class_mask needs to be of the form 1 x H x W of type long.
        Parameters:
            row: the row to plot the image
            col: the clolumn to plot the image
            class_mask: Tensor of shape 1 x H x W
            num_classes: number of classes
            colors: list of colors to plot. RGB. eg: [(0,0,255)]
            alpha: alpha-visibility of the overlay. Default 0.4
        """
        # one-hot encode the classes
        class_masks = torch.nn.functional.one_hot(class_mask[0].long(), num_classes=num_classes).detach().cpu().numpy()
        img = np.zeros((*class_masks.shape[:2], 3))
        for c in range(num_classes):
            img[class_masks[:,:,c] == 1] = np.array(colors[c]) / 255
        # back to tensor for the next function
        img = torch.tensor(img).permute(-1, 0, 1)
        self.plot_overlay(row, col, img, alpha=alpha)


    def plot_overlay(self, row, col, mask, alpha=0.4, vmin=None, vmax=None):
        """
        imposes an overlay onto a plot
        Overlay needs to be of the form C x H x W
        C needs to be either C=1 or C=3
        Parameters:
            row: the row to plot the image
            col: the clolumn to plot the image
            mask: Tensor of shape C x H x W
            alpha: alpha-visibility of the overlay. Default 0.4
            vmin: optinal lower bound for color scaling
            vmax: optional higher bound for color scaling
        """
        # convert to numpy
        mask = transforms.image_to_numpy(mask)
        if len(mask.shape) == 2:
            # plot greyscale image
            self.axs[row, col].imshow(mask, cmap='jet', vmin=vmin, vmax=vmax, interpolation='none', alpha=alpha)
        elif len(mask.shape) == 3:
            # last channel is color channel
            self.axs[row, col].imshow(mask, alpha=alpha)
        return self

    def plot_transform_grid(
        self, row, col, inv_flow, interval=5, linewidth=0.5, title=None, color='#000000FF' , overlay=False
    ):
        """
        plots a transformation of the form 2 x H x W at position row, col.
        Parameters:
            row: the row to plot the image
            col: the clolumn to plot the image
            flow: Tensor of shape 2 x H x W
            interval: spacing of grid lines. default 5.
            title: optional title
            color: the color of the grid. Default '#000000FF'
            overlay: bool, is the grid an overlay over an existing image? Default False
        """
        # convert to transform
        idty = Identity()
        inv_transform = inv_flow + idty(inv_flow.unsqueeze(0))[0]

        # convert to numpy
        inv_transform = transforms.image_to_numpy(inv_transform)

        if not overlay:
            # only set up frame if this is not an overlay
            self.axs[row, col].invert_yaxis()
            self.axs[row, col].set_aspect("equal")
            self.axs[row, col].title.set_text(title)

        for r in range(0, inv_transform.shape[0], interval):
            self.axs[row, col].plot(
                inv_transform[r, :, 1], inv_transform[r, :, 0], color.lower(), linewidth=linewidth
            )
        for c in range(0, inv_transform.shape[1], interval):
            self.axs[row, col].plot(
                inv_transform[:, c, 1], inv_transform[:, c, 0], color.lower(), linewidth=linewidth
            )
        return self

    def plot_transform_vec(
        self, row, col, flow, interval=5, arrow_length=1.0, linewidth=1.0, title=None
    ):
        """
        plots a transformation of the form 2 x H x W at position row, col.
        Parameters:
            row: the row to plot the image
            col: the clolumn to plot the image
            flow: Tensor of shape 2 x H x W
            interval: spacing of grid lines. default 5.
            title: optional title
        """
        # get identity
        idty_transform = Identity()
        idty = idty_transform(flow.unsqueeze(0))[0]

        # convert to numpy
        flow = transforms.image_to_numpy(flow)
        idty = transforms.image_to_numpy(idty)

        # extract components
        X = idty[..., 1]  # y, x indexed
        Y = idty[..., 0]

        U = flow[..., 1]
        V = -flow[
            ..., 0
        ]  # invert Y numerical vlaue, as plt.quiver ignores inverted axis.

        # calculate magnitude
        M = np.hypot(U, V)

        self.axs[row, col].invert_yaxis()
        self.axs[row, col].set_aspect("equal")
        self.axs[row, col].title.set_text(title)

        self.axs[row, col].quiver(
            X[::interval, ::interval],
            Y[::interval, ::interval],
            U[::interval, ::interval],
            V[::interval, ::interval],
            M[::interval, ::interval],
            units="x",
            width=linewidth,
            scale=1 / arrow_length,
            cmap="Blues",
        )
        return self


    def show(self):
        plt.show()

    def save(self, path, close=True):
        """
        saves the current figure.
        Parameters:
            path: path to save at. Including extension. eg. '~/my_fig.png'
            close: Bool, closes the figure when set.
        """
        plt.savefig(path)
        if close:
            plt.close(self.fig)
